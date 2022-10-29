#pragma once
#include "graph/mem_bulk.hpp"
#include <bitset>

class graph_t
{
private:
    // graph info
    bool is_in_graph; // 0 for out-graph, 1 for in-graph
    vid_t nverts; // number of vertices
    sid_t snap_id;
    vertex_t** vertices;

    // adjlists of levelgraph
    mempool_t* vbuf_pool;
    mempool_t** pblk_pools;
    mempool_t* vert_pool;
    mempool_t* snap_pool;
	thd_mem_t* thd_mem;

    // metric info
    metrics &m;

public:
    graph_t(bool _is_in_graph, vid_t _nverts, mempool_t* _vbuf_pool, mempool_t** _pblk_pool, mempool_t* _vert_pool, mempool_t* _snap_pool, metrics &_m)
        : is_in_graph(_is_in_graph), nverts(_nverts), vbuf_pool(_vbuf_pool), pblk_pools(_pblk_pool), vert_pool(_vert_pool), snap_pool(_snap_pool), m(_m){
        vertices = (vertex_t**)calloc(sizeof(vertex_t*), nverts);
        // logstream(LOG_INFO) << "calloc " << ((nverts * sizeof(vertex_t)) >> 20) << "MB in DRAM, for "<< nverts << " vertices of type vertex_t, size of each = " << sizeof(vertex_t) << std::endl;
        thd_mem = new thd_mem_t(vbuf_pool, pblk_pools, vert_pool, snap_pool);
    }

    ~graph_t(){
        delete thd_mem;
        free(vertices);
    }

    inline bool get_is_in_graph(){ return is_in_graph;}
    inline vid_t get_vcount(){ return nverts;}
    inline vertex_t* get_vertex(vid_t vid){ return vertices[vid];}
    inline void set_vertex(vid_t vid, vertex_t* vert){ vertices[vid] = vert;}
    inline vertex_t* new_vertex() { return thd_mem->new_vertex(); }
    inline snap_t* new_snap() { return thd_mem->new_snap(); }
    inline void print_free_vbufs_size(){ thd_mem->print_free_vbufs_size(); }

    inline degree_t get_degree(vid_t vid){ 
        vertex_t* vert =  vertices[vid];
        if(!vert) return 0;
        return vert->get_degree();
    }

    inline void clwb_pblk(pblock_t* cur_blk){
        // index_t cur_blk_size = cur_blk->get_max_nebrcount()*sizeof(vid_t)+sizeof(pblock_t);
        // if(cur_blk_size > CACHE_LINE_SIZE){
        index_t cur_blk_size = cur_blk->get_nebrcount()*sizeof(vid_t)+sizeof(pblock_t);
        if(cur_blk_size >= XPLINE_SIZE){
            clwbmore((char *)cur_blk, ((char *)cur_blk)+cur_blk_size-1);
        }
    }

    inline void set_pblk_pools(mempool_t** new_pblk_pools) {
        pblk_pools = new_pblk_pools;
        thd_mem->set_pblk_pools(new_pblk_pools);
    }
    
    void buffer_range_edges(edge_t* edges, index_t count, uint16_t snap_id1);
    void increment_degree(vid_t vid);
    void decrement_degree(vid_t vid);
    void buffer_nebr(vid_t vid, vid_t nebr);
    void delete_nebr(vid_t vid, vid_t nebr);
    degree_t find_nebr(vid_t vid, vid_t nebr);
    void compress();
    void compress_nebrs(vid_t vid);

    buffer_t* update_vbuf(vertex_t* vert);
    pblock_t* update_last_block(vid_t vid);
    index_t comp_vbuf_size(degree_t max_count);
    index_t comp_pblk_size(degree_t max_count);
    void archive_nebr(vid_t vid, vid_t nebr);
    void archive_vbuf(vid_t vid);
    void archive_and_free_vbuf(vid_t vid);
    void archive_range_vbufs(vid_t v_start, vid_t v_end, vid_t step);

    degree_t query_nebrs(vid_t vid);
    degree_t get_nebrs(vid_t vid, vid_t* neighbors);
    degree_t get_nebrs(vid_t vid, vid_t* ptr, sdegree_t count);
    degree_t get_nebrs_from_vbuf(vid_t vid, vid_t* neighbors);
    degree_t get_nebrs_from_pblks(vid_t vid, vid_t* neighbors);
    degree_t compact_vbuf_pblks(vid_t vid);
    bool compact_all_vbuf_pblks();
    void compact();
    void compact_nebrs(vid_t vid);
    
}; // class graph_t

/* -------------------------------------------------------------- */
// update graph
void graph_t::buffer_range_edges(edge_t* edges, index_t count, uint16_t snap_id1){ 
    snap_id = snap_id1;
    vid_t src, dst;
    // count temporary degree of each vertices in current range_edges
    for(index_t i = 0; i < count; ++i){
        src = edges[i].src;
        if (!IS_DEL(src)) increment_degree(TO_SID(src));
        else decrement_degree(TO_SID(src));
    }
    // buffer edges one by one
    for(index_t i = 0; i < count; ++i){
        src = edges[i].src;
        dst = edges[i].dst;
        if (!IS_DEL(src)) buffer_nebr(TO_SID(src), dst);
        else delete_nebr(TO_SID(src), dst);
    }
}

void graph_t::increment_degree(vid_t vid){
    vertex_t* vert = vertices[vid];
    if(vert == 0){
        vert = thd_mem->new_vertex();
        set_vertex(vid, vert);
    }
    snap_t* vsnap = vert->get_snap();
    if (vsnap == 0 || vsnap->id < snap_id) {
		//allocate new snap blob 
        snap_t* next_snap = vert->recycle_snap(snap_id);
		if (next_snap == 0) {
            next_snap = thd_mem->new_snap();
            next_snap->id = snap_id;
            if(vsnap){ next_snap->degree = vsnap->degree;}
            vert->set_snap(next_snap);
        }
		vsnap = next_snap;
	}
#ifdef DEL
    vsnap->degree.add_count++;
#else
    vsnap->degree++;
#endif
}

void graph_t::decrement_degree(vid_t vid){
    vertex_t* vert = vertices[vid];
    if(vert == 0){
        vert = thd_mem->new_vertex();
        set_vertex(vid, vert);
    }
    snap_t* vsnap = vert->get_snap();
    if (vsnap == 0 || vsnap->id < snap_id) {
		//allocate new snap blob 
        snap_t* next_snap = vert->recycle_snap(snap_id);
		if (next_snap == 0) {
            next_snap = thd_mem->new_snap();
            next_snap->id = snap_id;
            if(vsnap){ next_snap->degree = vsnap->degree;}
            vert->set_snap(next_snap);
        }
		vsnap = next_snap;
	}
#ifdef DEL
    assert((vsnap->degree.del_count < MAX_DEL_DEGREE) && (vsnap->degree.del_count >= 0));
	vsnap->degree.del_count++;
#else
	assert(0);
#endif
}

/* -------------------------------------------------------------- */
void graph_t::buffer_nebr(vid_t vid, vid_t nebr){
    vertex_t* vert = vertices[vid];
    buffer_t* vbuf = vert->vbuf;
    if(vbuf == 0){
        vbuf = update_vbuf(vert);
        if(vbuf == 0){
            // logstream(LOG_INFO) << "New vbuf fail for vertex: " << vid << ", " << vert->get_degree() << endl;
            archive_nebr(vid, nebr);
            return ;
        }
    } 
    // vbuf->assert_valid();
    if(vbuf->is_full()){
        if(vbuf->is_max_vbuf()){ // || !(vbuf = update_vbuf(vert))){ // flush to pmem
            archive_vbuf(vid);
        } else {
            buffer_t* new_vbuf = update_vbuf(vert);
            if(new_vbuf == 0) {
                logstream(LOG_DEBUG) << "Increment vbuf fail for vertex: " << vid << ", " << vert->get_degree() << endl;
                archive_and_free_vbuf(vid);
                pblock_t* cur_blk = vert->get_last_block();
                cur_blk->assert_valid();
                cur_blk->add_nebr(nebr);
                if(CLWB) clwb_pblk(cur_blk);
                return;
            }
            vbuf = new_vbuf;
        }
    }
    vbuf->assert_valid();
    vbuf->add_nebr(nebr);
}

void graph_t::delete_nebr(vid_t vid, vid_t nebr) {
    vertex_t* vert = vertices[vid];
    degree_t location = find_nebr(vid, TO_SID(nebr));
    // std::cout << "delete vid = " << vid << ",nebr = " << nebr << ",location = " << location << std::endl;
    if (location != INVALID_DEGREE) {
        nebr = DEL_SID(location);
        buffer_t* vbuf = vert->vbuf;
        if(vbuf == 0){
            vbuf = update_vbuf(vert);
            if(vbuf == 0){
                // logstream(LOG_INFO) << "New vbuf fail for vertex: " << vid << ", " << vert->get_degree() << endl;
                archive_nebr(vid, nebr);
                return ;
            }
        } 
        // vbuf->assert_valid();
        if(vbuf->is_full()){
            if(vbuf->is_max_vbuf()){ // || !(vbuf = update_vbuf(vert))){ // flush to pmem
                archive_vbuf(vid);
            } else {
                buffer_t* new_vbuf = update_vbuf(vert);
                if(new_vbuf == 0) {
                    logstream(LOG_DEBUG) << "Increment vbuf fail for vertex: " << vid << ", " << vert->get_degree() << endl;
                    archive_and_free_vbuf(vid);
                    pblock_t* cur_blk = vert->get_last_block();
                    cur_blk->assert_valid();
                    cur_blk->add_nebr(nebr);
                    if(CLWB) clwb_pblk(cur_blk);
                    return;
                }
                vbuf = new_vbuf;
            }
        }
        vbuf->assert_valid();
        vbuf->add_nebr(nebr);
    } else {
#ifdef DEL
        snap_t* vsnap = vert->get_snap();
        vsnap->degree.del_count--;
#else
        assert(0);
#endif
    }
}

degree_t graph_t::find_nebr(vid_t vid, vid_t nebr) {    
    degree_t degree = get_degree(vid);
    if(degree == 0) return INVALID_DEGREE;

    vid_t* neighbors = new vid_t[degree];
    degree_t count = get_nebrs(vid, neighbors);

    degree_t ret_degree = INVALID_DEGREE;
    for(index_t i = 0; i < count; ++i) {
        if(neighbors[i] == nebr) {
            ret_degree = i;
            break;
        }
    }
    delete [] neighbors;
    return ret_degree;
}

void graph_t::compress() {
    #pragma omp for schedule (dynamic, 256) nowait
    for(vid_t vid = 0; vid < nverts; ++vid) {
        compress_nebrs(vid);
    }
}

void graph_t::compress_nebrs(vid_t vid) {
    vertex_t* vert = vertices[vid];
    if (vert == 0) return;
    snap_t* vsnap = vert->get_snap();
    if (vsnap == 0) return;

    sdegree_t sdegree = vsnap->degree;
    degree_t del_count = get_delcount(sdegree);
    if (del_count == 0) return;
	degree_t nebr_count = get_actual(sdegree);    

    // copy valid data from old pblock to new adjlist
    vid_t* ptr = new vid_t[nebr_count];
    degree_t ret = get_nebrs(vid, ptr, sdegree);
    assert(ret == nebr_count);

    // replace old pblock for vertex
    uint8_t socket_id = 0;
    if(NUMA_OPT == 2) socket_id = GET_SOCKETID(vid);
    else if(NUMA_OPT == 1) socket_id = (uint8_t)is_in_graph; // 0 for out-graph, 1 for in-graph
    degree_t sum_deg = nebr_count;
    degree_t index = 0;

    vert->set_1st_block(0);
    vert->set_last_block(0);

    while(sum_deg > 0) {
        index_t size = comp_pblk_size(sum_deg);
        pblock_t* cur_blk = thd_mem->alloc_pblk(size, socket_id);
        degree_t max_nebrcount = cur_blk->get_max_nebrcount();
        degree_t rel_nebrcount = std::min(sum_deg, max_nebrcount);
        cur_blk->set_nebrcount(rel_nebrcount);
        vid_t* vlist = cur_blk->get_adjlist();
        for(degree_t i = 0; i < rel_nebrcount; ++i) vlist[i] = ptr[index++];        
        vert->update_last_block(cur_blk);
        sum_deg -= rel_nebrcount;
    }
    vert->compress_degree();

    // free vertex buffer on dram
    buffer_t* vbuf = vert->get_vbuf();
    if(vbuf) thd_mem->free_vbuf(vbuf, vbuf->get_size());
    vert->set_vbuf(0);
}

index_t graph_t::comp_vbuf_size(degree_t max_count){
    if(!LEVELED_BUF) return MAX_VBUF_SIZE;  // set fixed buffer size
    // compute the propriate buffer size by vertex degree
    index_t size = 0;
    // if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 128) size = ALIGNMENT((max_count+3)*sizeof(vid_t)+sizeof(buffer_t), 256);
    if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 128) size = (index_t)pow(2, ceil(log2(ALIGNMENT((max_count+3)*sizeof(vid_t)+sizeof(buffer_t), 256))));
    else if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 64) size = 128;
    else if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 32) size = 64;
    else if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 16) size = 32;
    else if(max_count*sizeof(vid_t)+sizeof(buffer_t) > 8) size = 16;
    else size = 8;
    if(size < MIN_VBUF_SIZE) size = MIN_VBUF_SIZE;
    if(size > MAX_VBUF_SIZE) size = MAX_VBUF_SIZE;
    // cout << "deg max_count size " << deg << " " << max_count << " " << size << endl;
    return size;
}

index_t graph_t::comp_pblk_size(degree_t max_count){
    index_t size = 0;
    // if(max_count > 256 || deg > 8192) size = ALIGNMENT(max_count*sizeof(vid_t)+sizeof(pblock_t), 4096);
    if(max_count > 256) size = ALIGNMENT(max_count*sizeof(vid_t)+sizeof(pblock_t), 4096);
    else if(max_count*sizeof(vid_t)+sizeof(pblock_t) > 128) size = ALIGNMENT(max_count*sizeof(vid_t)+sizeof(pblock_t), 256);
    else if(max_count*sizeof(vid_t)+sizeof(pblock_t) > 64) size = 128;
    else if(max_count*sizeof(vid_t)+sizeof(pblock_t) > 32) size = 64;
    else size = 32;
    // cout << "deg max_count size " << deg << " " << max_count << " " << size << endl;
    return size;
}

buffer_t* graph_t::update_vbuf(vertex_t* vert){
    assert(vert);
    // snap_t* vsnap = vert->get_snap();
    // assert(vsnap);
    // degree_t deg = vsnap->degree;
    // degree_t max_count = deg;
    // if(vsnap->prev) max_count = max_count - vsnap->prev->degree;
    // index_t size = comp_vbuf_size(vsnap->degree);
    degree_t max_count = vert->get_degree();
    assert(max_count);
    index_t size = comp_vbuf_size(max_count);
    buffer_t* vbuf = vert->vbuf;
    if(vbuf == 0){ // allocate dram space for vertex buffer
        if(!(vbuf = thd_mem->alloc_vbuf(size))) return 0; 
    } else {
        // vbuf->assert_valid();
        buffer_t* new_vbuf = thd_mem->alloc_vbuf(size);
        if(!new_vbuf) return 0; 
        // new_vbuf->assert_valid();
        new_vbuf->add_nebrs(vbuf->get_adjlist(), vbuf->get_nebrcount());
        thd_mem->free_vbuf(vbuf, vbuf->get_size()); 
        vbuf = new_vbuf;
    }
    vert->set_vbuf(vbuf);
    return vbuf;
}

inline pblock_t* graph_t::update_last_block(vid_t vid){
    vertex_t* vert = vertices[vid];
    blk_deg_t vbuf_count = 0;
    if(vert->vbuf) vbuf_count = vert->vbuf->get_nebrcount();
    snap_t* vsnap = vert->get_snap();
    assert(vsnap);
    degree_t deg = get_total(vsnap->degree);
    degree_t max_count = deg;
    if(vsnap->prev) max_count = max_count - get_total(vsnap->prev->degree) + vbuf_count;
    index_t size = comp_pblk_size(max_count);

    uint8_t socket_id = 0;
    if(NUMA_OPT == 2) socket_id = GET_SOCKETID(vid);
    else if(NUMA_OPT == 1) socket_id = (uint8_t)is_in_graph; // 0 for out-graph, 1 for in-graph
    pblock_t* cur_blk = thd_mem->alloc_pblk(size, socket_id);
    vert->update_last_block(cur_blk);
    return cur_blk;
}

inline void graph_t::archive_nebr(vid_t vid, vid_t nebr){
    pblock_t* cur_blk = vertices[vid]->get_last_block(); 
    if(cur_blk == 0 || cur_blk->is_full()) cur_blk = update_last_block(vid); 
    cur_blk->assert_valid();
    cur_blk->add_nebr(nebr);
}

void graph_t::archive_vbuf(vid_t vid){
    buffer_t* vbuf;
    blk_deg_t vbuf_nebrcount;
    if(!(vbuf = vertices[vid]->vbuf) || !(vbuf_nebrcount = vbuf->get_nebrcount())) return ;
    blk_deg_t vbuf_maxcount = vbuf->get_max_nebrcount();
    // vbuf->assert_valid();

    pblock_t* cur_blk = vertices[vid]->get_last_block(); 
    if(cur_blk == 0) cur_blk = update_last_block(vid); 
    cur_blk->assert_valid();
    blk_deg_t pblk_count = cur_blk->get_nebrcount();
    blk_deg_t pblk_maxcount = cur_blk->get_max_nebrcount();
    blk_deg_t rest_count = pblk_maxcount - pblk_count;
    if(vbuf_nebrcount + 1 <= rest_count){
        if(pblk_count + vbuf_nebrcount > pblk_maxcount) logstream(LOG_FATAL) << pblk_count << " " << vbuf_nebrcount << " " << pblk_maxcount << endl;
        cur_blk->add_nebrs(vbuf->get_adjlist(), vbuf_nebrcount);
    } else {
        if(rest_count){ 
            if(pblk_count + rest_count > pblk_maxcount) logstream(LOG_FATAL) << pblk_count << " " << rest_count << " " << pblk_maxcount << endl;
            cur_blk->add_nebrs(vbuf->get_adjlist(), rest_count);
            if(CLWB) clwb_pblk(cur_blk);
        }
        cur_blk = update_last_block(vid);
        if(cur_blk->get_nebrcount() + vbuf_nebrcount-rest_count > cur_blk->get_max_nebrcount()) 
            logstream(LOG_FATAL) << "Wrong vbuf count or pblk count: " << cur_blk->get_nebrcount() << " " << cur_blk->get_max_nebrcount() << " " << vbuf_nebrcount << " " << vbuf_maxcount << " " << rest_count << endl;
        cur_blk->add_nebrs(vbuf->get_adjlist()+rest_count, vbuf_nebrcount-rest_count);
    }
    vbuf->set_nebrcount(0);
}

inline void graph_t::archive_and_free_vbuf(vid_t vid){
    archive_vbuf(vid);
    // free dram space for vertex buffer
    buffer_t* vbuf = vertices[vid]->get_vbuf();
    thd_mem->free_vbuf(vbuf,vbuf->get_size());
    vertices[vid]->set_vbuf(0);
}

void graph_t::archive_range_vbufs(vid_t v_start, vid_t v_end, vid_t step){
    if(v_start < v_end){
        // logstream(LOG_WARNING) << "archive_range: [" << v_start << ", " << v_end << "), step = " << step << ", tid = " << omp_get_thread_num() << std::endl;
        vertex_t* vert;
        for(vid_t v = v_start; v < v_end; v += step){
            if(!(vert = vertices[v]) || !(vert->get_vbuf()) ) continue;
            archive_vbuf(v);
            buffer_t* vbuf = vert->get_vbuf();
            if(!MEMPOOL && vbuf) { free(vbuf);}
            // thd_mem->free_vbuf(vbuf,vbuf->get_size());
            vbuf = 0;
            vert->set_vbuf(0);
            if(CLWB){ // flush pblk proactively
                pblock_t* cur_blk = vert->get_last_block();
                if(cur_blk) clwb_pblk(cur_blk);
            }
        }
    }
    if(MEMPOOL) thd_mem->clear_vbuf_on_pool();
}

/* -------------------------------------------------------------- */
// graph query
degree_t graph_t::query_nebrs(vid_t vid){
    if(vid >= nverts){
        logstream(LOG_ERROR) << "Invalid vid, as vid: " << vid << " >= nverts:" << nverts << std::endl;
        return 0;
    }
    degree_t degree = get_degree(vid);
    if(degree == 0){
        logstream(LOG_INFO) << "neighbors of " << vid << " = NULL, as degree = " << degree << std::endl;
        return 0;
    }
    vid_t* neighbors = new vid_t[degree];
    degree_t count = get_nebrs(vid, neighbors);
    if(count != degree){ logstream(LOG_WARNING) << "Inconsistant degrees of " << vid << " = " << degree << " " << count << std::endl; degree = count;}

    logstream(LOG_INFO) << "neighbors of " << vid << " = ";
    for(index_t i = 0; i < degree; ++i)
        logstream(LOG_INFO) << neighbors[i] << ", ";
    logstream(LOG_INFO) << "degree = " << degree << std::endl;
    delete [] neighbors;
    return count;
}

degree_t graph_t::get_nebrs(vid_t vid, vid_t* neighbors){
    assert(vid < nverts);
    degree_t pcount = get_nebrs_from_pblks(vid, neighbors);
    degree_t dcount = get_nebrs_from_vbuf(vid, neighbors+pcount);
    return pcount + dcount;
}

degree_t graph_t::get_nebrs(vid_t vid, vid_t* ptr, sdegree_t count) {
    vertex_t* vert = vertices[vid];
    if (vert == 0) return 0;

    degree_t del_count = get_delcount(count);
    degree_t delta_degree = get_total(count);
    degree_t total_count = 0;
    
    if (del_count == 0) {
        total_count = get_nebrs(vid, ptr);
        assert(total_count == delta_degree);
    } else {
        degree_t nebr_count = get_actual(count);
        degree_t other_count = delta_degree - nebr_count;
        degree_t* del_pos = (degree_t*)calloc(2*del_count, sizeof(degree_t));
        vid_t* others = (vid_t*)calloc(other_count, sizeof(vid));

        degree_t pos = 0;
        degree_t idel = 0;
        degree_t other_pos = 0;
        bool is_del = false;

        degree_t local_degree = get_degree(vid);
        vid_t* local_adjlist = new vid_t[local_degree];
        degree_t degree = get_nebrs(vid, local_adjlist);
        assert(local_degree == degree);

        for (vid_t i = 0; i < degree; ++i) {
            is_del = IS_DEL(local_adjlist[i]);
            if (is_del) {
                pos = UNDEL_SID(local_adjlist[i]);
                if (total_count < nebr_count){
                    del_pos[idel++] = pos;
                    del_pos[idel++] = total_count;
                } else {
                    if (pos < nebr_count) {
                        del_pos[idel++] = pos;
                    }
                }
            } 
            if (total_count < nebr_count) { //normal case
                ptr[total_count++] = local_adjlist[i];
            } else { //space is full
                others[other_pos++] = local_adjlist[i];
                if (is_del && pos >= total_count) {
                    others[pos-total_count] = local_adjlist[i];
                }
            }
        }

        assert(other_pos <= other_count);
        assert(idel <= 2*del_count);
        while (other_pos != 0 && idel !=0) {
            if (IS_DEL(others[--other_pos])) continue;
            pos = del_pos[--idel];
            ptr[pos] = others[other_pos];    
        }
        free(del_pos);
        free(others);
    }
    return total_count;
}

degree_t graph_t::get_nebrs_from_vbuf(vid_t vid, vid_t* neighbors){
    assert(vid < nverts);
    degree_t count = 0;
    index_t bv_cnt = 0;
    const vid_t* adj_list1 = 0;
    
    // query from DRAM block
    buffer_t* vbuf = vertices[vid]->get_vbuf();
    if(vbuf) {
        bv_cnt = vbuf->get_nebrcount();
        if(bv_cnt > 0){
            // if(vid == 1) vbuf->print_adjlist();
            adj_list1 = vbuf->get_adjlist();
            for(index_t i = 0; i < bv_cnt; ++i){
                neighbors[count++] = adj_list1[i];
            }
        }
        // assert(bv_cnt == count);
    }
    return count;
}

degree_t graph_t::get_nebrs_from_pblks(vid_t vid, vid_t* neighbors){
    assert(vid < nverts);
    degree_t count = 0;
    index_t bv_cnt = 0;
    const vid_t* adj_list1 = 0;

    // query from NVM blocks
    pblock_t* cur_blk = vertices[vid]->get_1st_block();
    while (cur_blk) {
        bv_cnt = cur_blk->get_nebrcount();
        if (bv_cnt > 0) {
            adj_list1 = cur_blk->get_adjlist();
            for (index_t i = 0; i < bv_cnt; ++i) {
                neighbors[count++] = adj_list1[i];
            }
        }
        cur_blk = cur_blk->get_next();
    }
    return count;
}

degree_t graph_t::compact_vbuf_pblks(vid_t vid){
    assert(vid < nverts);
    size_t size1 = comp_pblk_size(get_degree(vid));

    uint8_t socket_id = 0;
    if(NUMA_OPT == 2) socket_id = GET_SOCKETID(vid);
    else if(NUMA_OPT == 1) socket_id = (uint8_t)is_in_graph; // 0 for out-graph, 1 for in-graph
    pblock_t* final_blk = thd_mem->alloc_pblk(size1, socket_id);

    vertex_t* vert = vertices[vid];
    degree_t count = 0, bv_cnt = 0;
    vid_t* adj_list1 = 0; 
    // copy from NVM blocks
    pblock_t* cur_blk = vert->get_1st_block();
    while (cur_blk) {
        bv_cnt = cur_blk->get_nebrcount();
        if (bv_cnt > 0) {
            adj_list1 = cur_blk->get_adjlist();
            final_blk->add_nebrs(adj_list1, bv_cnt);
            cur_blk->set_nebrcount(0);
            count += bv_cnt;
        }
        // TODO --> thd_mem->free_pblk(cur_blk, cur_blk->get_size())
        cur_blk = cur_blk->get_next();
    }

    // copy from DRAM buffers
    buffer_t* vbuf = vert->get_vbuf();
    if(vbuf) {
        bv_cnt = vbuf->get_nebrcount();
        if(bv_cnt > 0){
            // if(vid == 1) vbuf->print_adjlist();
            adj_list1 = vbuf->get_adjlist();
            final_blk->add_nebrs(adj_list1, bv_cnt);
            vbuf->set_nebrcount(0);
            count += bv_cnt;
        }
        thd_mem->free_vbuf(vbuf,vbuf->get_size());
        vert->set_vbuf(0);
    }

    vert->update_first_block(final_blk);
    vert->set_last_block(final_blk); // after free previous pblks (TODO)
    return count;
}

bool graph_t::compact_all_vbuf_pblks(){
    uint8_t num_subgraphs = 1;
    if(NUMA_OPT == 2) num_subgraphs = NUM_SOCKETS;
    for(uint8_t socket_id = 0; socket_id < num_subgraphs; socket_id++){
        #pragma omp parallel num_threads (THD_COUNT) 
        {
            tid_t tid = omp_get_thread_num();
            bind_thread_to_socket(tid, socket_id);
            #pragma omp for schedule(static) nowait
            for(vid_t vid = 0; vid < nverts; vid += num_subgraphs){
                if(get_degree(vid) == 0) continue;
                compact_vbuf_pblks(vid);
            }
        }
    }
    return true;
}

void graph_t::compact() {
    #pragma omp for schedule (dynamic, 256) nowait
    for(vid_t vid = 0; vid < nverts; ++vid) {
        compact_nebrs(vid);
    }
}

void graph_t::compact_nebrs(vid_t vid) {
    vertex_t* vert = vertices[vid];
    if (vert == 0) return;
    snap_t* vsnap = vert->get_snap();
    if (vsnap == 0) return;

    sdegree_t sdegree = vsnap->degree;
	degree_t nebr_count = get_actual(sdegree);    

    // copy valid data from old pblock to new adjlist
    vid_t* ptr = new vid_t[nebr_count];
    degree_t ret = get_nebrs(vid, ptr, sdegree);
    assert(ret == nebr_count);

    // replace old pblock for vertex
    uint8_t socket_id = 0;
    if(NUMA_OPT == 2) socket_id = GET_SOCKETID(vid);
    else if(NUMA_OPT == 1) socket_id = (uint8_t)is_in_graph; // 0 for out-graph, 1 for in-graph
    degree_t sum_deg = nebr_count;
    degree_t index = 0;

    vert->set_1st_block(0);
    vert->set_last_block(0);
    
    while(sum_deg > 0) {
        index_t size = comp_pblk_size(sum_deg);
        pblock_t* cur_blk = thd_mem->alloc_pblk(size, socket_id);
        degree_t max_nebrcount = cur_blk->get_max_nebrcount();
        degree_t rel_nebrcount = std::min(sum_deg, max_nebrcount);
        cur_blk->set_nebrcount(rel_nebrcount);
        vid_t* vlist = cur_blk->get_adjlist();
        for(degree_t i = 0; i < rel_nebrcount; ++i) vlist[i] = ptr[index++];        
        vert->update_last_block(cur_blk);
        sum_deg -= rel_nebrcount;
    }
    vert->compress_degree();

    // free vertex buffer on dram
    buffer_t* vbuf = vert->get_vbuf();
    if(vbuf) thd_mem->free_vbuf(vbuf, vbuf->get_size());
    vert->set_vbuf(0);
}