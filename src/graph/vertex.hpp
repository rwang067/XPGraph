#pragma once

#include "graph/blocks.hpp"

/** -------------------------------------------------------------- **/
class nebrcount_t {
public:
    degree_t    add_count;
    degree_t    del_count;
};

#ifdef DEL
#define MAX_DEL_DEGREE UINT16_MAX
class sdegree_t {
 public:
    degree_t add_count;
    uint16_t del_count;
public:
    inline sdegree_t(degree_t degree = 0) {
        add_count = 0;
        del_count = 0;
    }
    inline bool operator != (const sdegree_t& sdegree) {
        return ((add_count != sdegree.add_count) || (del_count != sdegree.del_count));
    }
};
#else 
typedef degree_t sdegree_t;
#endif

inline degree_t get_total(sdegree_t sdegree) {
#ifdef DEL
	return sdegree.add_count + sdegree.del_count;
#else
	return sdegree;
#endif
}

inline degree_t get_actual(sdegree_t sdegree) {
#ifdef DEL
	return sdegree.add_count - sdegree.del_count;
#else
	return sdegree;
#endif
}

inline degree_t get_delcount(sdegree_t sdegree) {
#ifdef DEL
	return sdegree.del_count;
#else
	return 0;
#endif
}

class  snap_t {
public:
    snap_t*     prev;//prev snapshot of this vid 
    sdegree_t  degree;
    sid_t  id;
    snap_t(){ prev = 0; degree = 0; id = 0;}
};

class vertex_t{
public:
    snap_t* vsnap;
    buffer_t* vbuf;
    pblock_t* first_blk;
    pblock_t* last_blk;

    vertex_t(){ vsnap = 0; vbuf = 0; first_blk = 0; last_blk = 0;}
    inline snap_t* get_snap() { return vsnap; } 
    inline void set_snap(snap_t* snap1) { 
        snap1->prev = vsnap;
        vsnap = snap1; 
    } 

    inline snap_t* recycle_snap(sid_t snap_id) { 
        if (0 == vsnap || 0 == vsnap->prev) return 0;
        
        index_t snap_count = 2;
        snap_t* vsnap1 = vsnap;
        snap_t* vsnap2 = vsnap->prev;

        while (vsnap2->prev != 0) {
            vsnap1 = vsnap2;
            vsnap2 = vsnap2->prev;
            ++snap_count;
        }
        if (snap_count < SNAP_COUNT) {
            return 0;
        }

        vsnap1->prev = 0;
        vsnap2->id = snap_id;
        vsnap2->degree = vsnap->degree;
        set_snap(vsnap2);
        return vsnap2;
    } 

    inline degree_t get_degree(){ 
        if(!vsnap) return 0;
        return get_total(vsnap->degree);
    }

    inline degree_t get_degree(sid_t snap_id){ 
        if(!vsnap) return 0;
        if(snap_id >= vsnap->id) return get_total(vsnap->degree);
        snap_t* snap = vsnap->prev;
        while (snap && snap_id < snap->id) {
            snap = snap->prev;
        }
        return get_total(vsnap->degree);
    }

    inline void compress_degree() {
    #ifdef DEL
        vsnap->degree.add_count -= vsnap->degree.del_count;
        vsnap->degree.del_count = 0;
    #endif
    }

    inline buffer_t* get_vbuf(){ return vbuf;}
    inline void set_vbuf(buffer_t* block){ vbuf = block;}
    inline pblock_t* get_1st_block(){ return first_blk;}
    inline void set_1st_block(pblock_t* block){ first_blk = block; }

    inline pblock_t* get_last_block(){
        // renew last_blk after recovery
        if (!last_blk && first_blk) {
            pblock_t* cur_blk = first_blk;
            while (cur_blk && cur_blk->get_next()) {
                cur_blk = cur_blk->get_next();
            }
            last_blk = cur_blk;
        }
        return last_blk;
    }

    inline void set_last_block(pblock_t* block){ 
        last_blk = block; 
    }
    
    inline void update_last_block(pblock_t* block){ 
        if(last_blk){
            last_blk->add_next(block);
            last_blk = block;
        } else {
            first_blk = block;
            last_blk = block;
        }
    }
    
    inline void update_first_block(pblock_t* block){ 
        if(first_blk){
            block->add_next(first_blk);
        }
        first_blk = block;
    }
};

// class vertex_bulk_t{
// public:
//     vertex_t* addr;
//     index_t count;
//     vertex_bulk_t(){addr = 0; count = 0;}
//     inline void alloc_vertex_bulk(index_t count1){
//         count = count1;
//         addr = (vertex_t*)calloc(sizeof(vertex_t), count);
//         logstream(LOG_WARNING) << "alloc_vertex_bulk: count = " << count << ", callocd " << ((count*sizeof(vertex_t)) >> 20) << "MB." << std::endl;
//     }
//     inline vertex_t* new_vertex(){
//         if(count == 0){
//             alloc_vertex_bulk(VERTEX_BULK_SIZE);
//         }
//         count--;
//         return addr++;
//     }
// };
