#!/bin/bash

## Test graph ingest time of GraphOne-P, then conduct graph query of each algorithm one by one. 

gop_path=$1
pmem0=$2
pmem1=$3
dataset_path=$4

clear_pmem() {
    rm -f ${pmem0}*
    rm -f ${pmem1}*
}

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_update.csv
echo "make_graph_time(s),VIRT(GB),RSS(GB),vunit_size(GB),snap_size(GB),global_range_size(GB),global_range_in_size(GB),elog_size(GB),adjlist_size(GB),local_buf_size(GB)" >> gop_update.csv
echo $cur_time "Graph query time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_query.csv
echo "time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> gop_query.csv
echo $cur_time "Graph compress time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_compress.csv
echo "compress_time(s)" >> gop_compress.csv
for(( times = 0; times < 1; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1} -i ${dataset_path}RMAT/RMAT4/bin -v 4000000 -j 0 -s 1 -d 1 -t 16
done
echo >> gop_update.csv
echo >> gop_query.csv
echo >> gop_compress.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4D/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_update.csv
echo "make_graph_time(s),VIRT(GB),RSS(GB),vunit_size(GB),snap_size(GB),global_range_size(GB),global_range_in_size(GB),elog_size(GB),adjlist_size(GB),local_buf_size(GB)" >> gop_update.csv
echo $cur_time "Graph query time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4D/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_query.csv
echo "time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> gop_query.csv
echo $cur_time "Graph compress time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT4D/bin -v 4000000 -j 0 -s 1 -d 1 -t 16" >> gop_compress.csv
echo "compress_time(s)" >> gop_compress.csv
for(( times = 0; times < 1; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1} -i ${dataset_path}RMAT/RMAT4D/bin -v 4000000 -j 0 -s 1 -d 1 -t 16
done
echo >> gop_update.csv
echo >> gop_query.csv
echo >> gop_compress.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_update.csv
echo "make_graph_time(s),VIRT(GB),RSS(GB),vunit_size(GB),snap_size(GB),global_range_size(GB),global_range_in_size(GB),elog_size(GB),adjlist_size(GB),local_buf_size(GB)" >> gop_update.csv
echo $cur_time "Graph query time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_query.csv
echo "time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> gop_query.csv
echo $cur_time "Graph compress time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_compress.csv
echo "compress_time(s)" >> gop_compress.csv
for(( times = 0; times < 1; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1} -i ${dataset_path}RMAT/RMAT64/bin -v 64000000 -j 0 -s 1 -d 1 -t 16
done
echo >> gop_update.csv
echo >> gop_query.csv
echo >> gop_compress.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64D/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_update.csv
echo "make_graph_time(s),VIRT(GB),RSS(GB),vunit_size(GB),snap_size(GB),global_range_size(GB),global_range_in_size(GB),elog_size(GB),adjlist_size(GB),local_buf_size(GB)" >> gop_update.csv
echo $cur_time "Graph query time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64D/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_query.csv
echo "time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> gop_query.csv
echo $cur_time "Graph compress time of GraphOne-P, with command: ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1}  -i ${dataset_path}RMAT/RMAT64D/bin -v 64000000 -j 0 -s 1 -d 1 -t 16" >> gop_compress.csv
echo "compress_time(s)" >> gop_compress.csv
for(( times = 0; times < 1; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ${gop_path}build/graphone32 -a ${pmem0} -b ${pmem1} -i ${dataset_path}RMAT/RMAT64D/bin -v 64000000 -j 0 -s 1 -d 1 -t 16
done
echo >> gop_update.csv
echo >> gop_query.csv
echo >> gop_compress.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of GraphOne-P end." >> gop_update.csv
echo $cur_time "Graph query time of GraphOne-P end." >> gop_query.csv
echo $cur_time "Graph compress time of GraphOne-P end." >> gop_compress.csv

mv gop_update.csv results/figxx/GraphOne-P.csv
mv gop_query.csv results/figxx/GraphOne-P-Q.csv
mv gop_compress.csv results/figxx/GraphOne-P-C.csv
