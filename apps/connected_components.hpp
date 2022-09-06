#pragma once
#include <omp.h>
#include <random>
#include <algorithm>
#include <utility>
#include <vector>
#include <unordered_map>
#include <cinttypes>
#include <functional>
#include <libxpgraph.h>

bool compare_and_swap(vid_t &x, vid_t &old_val, vid_t &new_val) {
    return __sync_bool_compare_and_swap(&x, old_val, new_val);
}

// Returns k pairs with largest values from list of key-value pairs
template<typename KeyT, typename ValT>
std::vector<std::pair<ValT, KeyT>> TopK(
    const std::vector<std::pair<KeyT, ValT>> &to_sort, size_t k) {
    std::vector<std::pair<ValT, KeyT>> top_k;
    ValT min_so_far = 0;
    for (auto kvp : to_sort) {
        if ((top_k.size() < k) || (kvp.second > min_so_far)) {
            top_k.push_back(std::make_pair(kvp.second, kvp.first));
            std::sort(top_k.begin(), top_k.end(),
                        std::greater<std::pair<ValT, KeyT>>());
            if (top_k.size() > k)
                top_k.resize(k);
            min_so_far = top_k.back().first;
        }
    }
  return top_k;
}

// Place nodes u and v in same component of lower component ID
void Link(vid_t u, vid_t v, vid_t* comp) {
  vid_t p1 = comp[u];
  vid_t p2 = comp[v];
  while (p1 != p2) {
    vid_t high = p1 > p2 ? p1 : p2;
    vid_t low = p1 + (p2 - high);
    vid_t p_high = comp[high];
    // Was already 'low' or succeeded in writing 'low'
    if ((p_high == low) ||
        (p_high == high && compare_and_swap(comp[high], high, low)))
      break;
    p1 = comp[comp[high]];
    p2 = comp[low];
  }
}

// Reduce depth of tree for each component to 1 by crawling up parents
void Compress(vid_t v_count, vid_t* comp) {
    #pragma omp parallel for schedule(dynamic, 16384)
    for (vid_t n = 0; n < v_count; n++) {
        while (comp[n] != comp[comp[n]]) {
            comp[n] = comp[comp[n]];
        }
    }
}

vid_t SampleFrequentElement(vid_t* comp, vid_t v_count, index_t num_samples = 1024) {
  std::unordered_map<vid_t, int> sample_counts(32);
  using kvp_type = std::unordered_map<vid_t, int>::value_type;
  // Sample elements from 'comp'
  std::mt19937 gen;
  std::uniform_int_distribution<vid_t> distribution(0, v_count - 1);
  for (vid_t i = 0; i < num_samples; i++) {
    vid_t n = distribution(gen);
    sample_counts[comp[n]]++;
  }
  // Find most frequent element in samples (estimate of most frequent overall)
  auto most_frequent = std::max_element(
    sample_counts.begin(), sample_counts.end(),
    [](const kvp_type& a, const kvp_type& b) { return a.second < b.second; });
  float frac_of_graph = static_cast<float>(most_frequent->second) / num_samples;
  std::cout
    << "Skipping largest intermediate component (ID: " << most_frequent->first
    << ", approx. " << static_cast<int>(frac_of_graph * 100)
    << "% of the graph)" << std::endl;
  return most_frequent->first;
}

vid_t test_connected_components(XPGraph* xpgraph, index_t neighbor_rounds = 2) {
    std::cout << "test_connected_components..." << std::endl;
    vid_t v_count = xpgraph->get_vcount();
    vid_t* comp = (vid_t*)calloc(sizeof(vid_t), v_count);

    // Initialize each node to a single-node self-pointing tree
    #pragma omp parallel for
    for (vid_t v = 0; v < v_count; v++) {
        comp[v] = v;
    }

    // Process a sparse sampled subgraph first for approximating components.
    // Sample by processing a fixed number of neighbors for each node (see paper)
    for (index_t r = 0; r < neighbor_rounds; ++r) {
        #pragma omp parallel 
        {
            #pragma omp for nowait
            for (vid_t u = 0; u < v_count; u++) {
                degree_t nebr_count, local_degree;
                vid_t* local_adjlist;
                nebr_count = xpgraph->get_out_degree(u);
                if (nebr_count == 0) continue;
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = r; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                    break;
                }
                delete [] local_adjlist;
            }
        }
    }
    Compress(v_count, comp);
    

    vid_t c = SampleFrequentElement(comp, v_count);

    #pragma omp parallel 
    {
        #pragma omp for nowait
        for (vid_t u = 0; u < v_count; u++) {
            degree_t nebr_count, local_degree;
            vid_t* local_adjlist;
            if (comp[u] == c) continue;
            nebr_count = xpgraph->get_out_degree(u);
            if (nebr_count != 0) {
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = neighbor_rounds; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                }
                delete [] local_adjlist;
            }
            // To support directed graphs, process reverse graph completely
            nebr_count = xpgraph->get_in_degree(u);
            if (nebr_count == 0) continue;
            local_adjlist = new vid_t[nebr_count];
            local_degree  = xpgraph->get_in_nebrs(u, local_adjlist);
            assert(nebr_count == local_degree);
            for (vid_t v = 0; v < local_degree; v++) {
                Link(u, local_adjlist[v], comp);
            }
            delete [] local_adjlist;
        }
    }
    // Finally, 'compress' for final convergence
    Compress(v_count, comp);

    std::unordered_map<vid_t, vid_t> count;
    for (vid_t comp_i = 0; comp_i < v_count; comp_i++)
        count[comp[comp_i]] += 1;
    int k = 5;
    std::vector<std::pair<vid_t, vid_t>> count_vector;
    count_vector.reserve(count.size());
    for (auto kvp : count) count_vector.push_back(kvp);
    std::vector<std::pair<vid_t, vid_t>> top_k = TopK(count_vector, k);
    k = std::min(k, static_cast<int>(top_k.size()));
    std::cout << k << " biggest clusters" << std::endl;
    for (auto kvp : top_k)
        std::cout << kvp.second << ":" << kvp.first << std::endl;
    std::cout << "There are " << count.size() << " components" << std::endl;

    free(comp);
    return count.size();
}

vid_t test_connected_components_numa(XPGraph* xpgraph, index_t neighbor_rounds = 2) {
    std::cout << "test_connected_components_numa..." << std::endl;
    vid_t v_count = xpgraph->get_vcount();
    vid_t* comp = (vid_t*)calloc(sizeof(vid_t), v_count);

    // Initialize each node to a single-node self-pointing tree
    #pragma omp parallel for
    for (vid_t v = 0; v < v_count; v++) {
        comp[v] = v;
    }

    // Process a sparse sampled subgraph first for approximating components.
    // Sample by processing a fixed number of neighbors for each node (see paper)
    for (index_t r = 0; r < neighbor_rounds; ++r) {
        #pragma omp parallel 
        {
            tid_t tid = omp_get_thread_num();
            // First process vertices in socket 0
            xpgraph->bind_cpu(tid, 0);
            #pragma omp for nowait
            for (vid_t u = 0; u < v_count; u+=2) {
                degree_t nebr_count, local_degree;
                vid_t* local_adjlist;
                nebr_count = xpgraph->get_out_degree(u);
                if (nebr_count == 0) continue;
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = r; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                    break;
                }
                delete [] local_adjlist;
            }
            // Then process vertices in socket 1
            xpgraph->bind_cpu(tid, 1);
            #pragma omp for nowait
            for (vid_t u = 1; u < v_count; u+=2) {
                degree_t nebr_count, local_degree;
                vid_t* local_adjlist;
                nebr_count = xpgraph->get_out_degree(u);
                if (nebr_count == 0) continue;
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = r; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                    break;
                }
                delete [] local_adjlist;
            }
        }
        Compress(v_count, comp);
        xpgraph->cancel_bind_cpu();
    }

    vid_t c = SampleFrequentElement(comp, v_count);

    #pragma omp parallel 
    {
        tid_t tid = omp_get_thread_num();
        // First process vertices in socket 0
        xpgraph->bind_cpu(tid, 0);
        #pragma omp for nowait
        for (vid_t u = 0; u < v_count; u+=2) {
            degree_t nebr_count, local_degree;
            vid_t* local_adjlist;
            if (comp[u] == c) continue;
            nebr_count = xpgraph->get_out_degree(u);
            if (nebr_count != 0) {
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = neighbor_rounds; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                }
                delete [] local_adjlist;
            }
            // To support directed graphs, process reverse graph completely
            nebr_count = xpgraph->get_in_degree(u);
            if (nebr_count == 0) continue;
            local_adjlist = new vid_t[nebr_count];
            local_degree  = xpgraph->get_in_nebrs(u, local_adjlist);
            assert(nebr_count == local_degree);
            for (vid_t v = 0; v < local_degree; v++) {
                Link(u, local_adjlist[v], comp);
            }
            delete [] local_adjlist;
        }
        
        // Then process vertices in socket 1
        xpgraph->bind_cpu(tid, 1);
        #pragma omp for nowait
        for (vid_t u = 1; u < v_count; u+=2) {
            degree_t nebr_count, local_degree;
            vid_t* local_adjlist;
            if (comp[u] == c) continue;
            nebr_count = xpgraph->get_out_degree(u);
            if (nebr_count != 0) {
                local_adjlist = new vid_t[nebr_count];
                local_degree  = xpgraph->get_out_nebrs(u, local_adjlist);
                assert(nebr_count == local_degree);
                for (vid_t v = neighbor_rounds; v < local_degree; v++) {
                    Link(u, local_adjlist[v], comp);
                }
                delete [] local_adjlist;
            }
            // To support directed graphs, process reverse graph completely
            nebr_count = xpgraph->get_in_degree(u);
            if (nebr_count == 0) continue;
            local_adjlist = new vid_t[nebr_count];
            local_degree  = xpgraph->get_in_nebrs(u, local_adjlist);
            assert(nebr_count == local_degree);
            for (vid_t v = 0; v < local_degree; v++) {
                Link(u, local_adjlist[v], comp);
            }
            delete [] local_adjlist;
        }
        xpgraph->cancel_bind_cpu();
    }

    // Finally, 'compress' for final convergence
    Compress(v_count, comp);

    // std::unordered_map<vid_t, vid_t> count;
    // for (vid_t comp_i = 0; comp_i < v_count; comp_i++)
    //     count[comp[comp_i]] += 1;
    // int k = 5;
    // std::vector<std::pair<vid_t, vid_t>> count_vector;
    // count_vector.reserve(count.size());
    // for (auto kvp : count) count_vector.push_back(kvp);
    // std::vector<std::pair<vid_t, vid_t>> top_k = TopK(count_vector, k);
    // k = std::min(k, static_cast<int>(top_k.size()));
    // std::cout << k << " biggest clusters" << std::endl;
    // for (auto kvp : top_k)
    //     std::cout << kvp.second << ":" << kvp.first << std::endl;
    // std::cout << "There are " << count.size() << " components" << std::endl;

    // free(comp);
    // return count.size();
    return 0;
}