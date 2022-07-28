
// #include <omp.h>
// #include <getopt.h>
// #include <stdlib.h>

#include <iostream>
#include <string>
#include <fstream>

#include <libxpgraph.h>
#include "apps/graph_benchmarks.hpp"

int main(int argc, const char ** argv)
{
    XPGraph *xpgraph = new XPGraph(argc, argv);
    xpgraph->import_graph_by_config();

    #pragma region test_neighbors
    double start, end; 
	start = mywtime();
    test_out_neighbors(xpgraph);
    test_in_neighbors(xpgraph);
	end = mywtime();
    std::cout << "test_out/in_neighbors cost: " << (end - start) << std::endl;
    #pragma endregion test_neighbors

    // test_graph_benchmarks(xpgraph);
    test_graph_benchmarks_numa(xpgraph);

    std::string statistic_filename = "pmg.csv";
    std::ofstream ofs;
    ofs.open(statistic_filename.c_str(), std::ofstream::out | std::ofstream::app );

    #pragma region test_flush_compact
    // // std::cout << "flush_all_vbufs..." << std::endl;
    // // xpgraph->flush_all_vbufs();
    // // test_out_neighbors(xpgraph);
    // // test_in_neighbors(xpgraph);
    // // { // graph benchmark test with subgraph based NUMA optimization 
    // //     // double time_1hop = 0, time_2hop = 0, time_bfs = 0, time_pagerank = 0, time_cc = 0;
    // //     for (int i = 0; i < 1; ++i) {
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "f,";
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "f,";
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "f,";
    // //     }
    // //     // ofs << time_1hop << "," << time_2hop << "," << time_bfs << "," << time_pagerank << "," << time_cc << ",";
    // // }

    // // std::cout << "compact_all_adjs..." << std::endl;
    // // xpgraph->compact_all_adjs();
    // // test_out_neighbors(xpgraph);
    // // test_in_neighbors(xpgraph);
    // // { // graph benchmark test with subgraph based NUMA optimization 
    // //     // double time_1hop = 0, time_2hop = 0, time_bfs = 0, time_pagerank = 0, time_cc = 0;
    // //     for (int i = 0; i < 1; ++i) {
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "c,";
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "c,";
    // //         ofs << test_1hop_numa(xpgraph, 1 << 24) << "c,";
    // //     }
    // //     // ofs << time_1hop << "," << time_2hop << "," << time_bfs << "," << time_pagerank << "," << time_cc << ",";
    // // }
    #pragma endregion test_flush_compact

    #pragma region test_savegraph
    std::string odirname = "/mnt/pmem1/wr/Recovery/";
    xpgraph->save_gragh();
    #pragma endregion test_savegraph

    ofs << std::endl;
    delete xpgraph;

    #pragma region test_xpgraph1
    // XPGraph *xpgraph1 = new XPGraph(argc, argv);
    // xpgraph1->import_graph_by_config();
    // test_out_neighbors(xpgraph1);
    // test_in_neighbors(xpgraph1);
    // { // graph benchmark test without NUMA optimization
    //     // double time_1hop = 0, time_2hop = 0, time_bfs = 0, time_pagerank = 0, time_cc = 0;
    //     for (int i = 0; i < 1; ++i) {
    //         ofs << test_1hop(xpgraph1, 1 << 24) << ",";
    //         ofs << test_1hop(xpgraph1, 1 << 24) << ",";
    //     }
    //     // ofs << time_1hop << "," << time_2hop << "," << time_bfs << "," << time_pagerank << "," << time_cc << ",";
    // }
    // ofs << std::endl;
    // delete xpgraph1;
    #pragma endregion test_xpgraph1
    
    ofs.close();
    return 0;
}
