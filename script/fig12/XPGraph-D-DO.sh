#!/bin/bash

dataset_path="/mnt/nvme1/wr/dataset"

## Graph ingest time of XPGraph-D in DRAM-only system
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D (DRAM Only) start..." >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 --dram_only 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 --dram_only 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 --dram_only 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 --dram_only 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 --dram_only 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 --dram_only 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --dram_only 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --dram_only 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D (DRAM Only), end." >> pmg.csv

mv pmg.csv results/fig12/XPGraph-D-DO.csv