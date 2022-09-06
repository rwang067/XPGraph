#!/bin/bash

## Test graph ingest/delete time of XPGraph, then conduct graph query of each algorithm one by one. 

pmem0=$1
pmem1=$2
dataset_path=$3

clear_pmem() {
    rm -f ${pmem0}*
    rm -f ${pmem1}*
}

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4/bin -v 4000000 --vbuf_pool 8 --pblk_pools 32 -q 1 --persist 0" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
echo $cur_time "Graph query time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4/bin -v 4000000 --vbuf_pool 8 --pblk_pools 32 --persist 0" >> xpgraph_query.csv
echo "[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)," >> xpgraph_query.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4/bin -v 4000000 --vbuf_pool 8 --pblk_pools 32 -q 1 --persist 0
done
echo >> xpgraph_update.csv
echo >> xpgraph_query.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4D/bin -v 4000000 --vbuf_pool 1 --pblk_pools 32 -q 1 --persist 0" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
echo $cur_time "Graph query time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4D/bin -v 4000000 --vbuf_pool 8 --pblk_pools 32 --persist 0" >> xpgraph_query.csv
echo "[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)," >> xpgraph_query.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT4D/bin -v 4000000 --vbuf_pool 8 --pblk_pools 32 -q 1 --persist 0
done
echo >> xpgraph_update.csv
echo >> xpgraph_query.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 -q 1 --persist 0" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
echo $cur_time "Graph query time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 --persist 0" >> xpgraph_query.csv
echo "[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)," >> xpgraph_query.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 -q 1 --persist 0
done
echo >> xpgraph_update.csv
echo >> xpgraph_query.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64D/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 -q 1 --persist 0" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
echo $cur_time "Graph query time of XPGraph, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64D/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 --persist 0" >> xpgraph_query.csv
echo "[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)," >> xpgraph_query.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    clear_pmem
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}RMAT/RMAT64D/bin -v 64000000 --vbuf_pool 16 --pblk_pools 128 -q 1 --persist 0
done
echo >> xpgraph_update.csv
echo >> xpgraph_query.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph end." >> xpgraph_update.csv
echo $cur_time "Graph query time of XPGraph end." >> xpgraph_query.csv

mv xpgraph_update.csv results/figxx/XPGraph-DEL-U.csv
mv xpgraph_query.csv results/figxx/XPGraph-DEL-Q.csv
