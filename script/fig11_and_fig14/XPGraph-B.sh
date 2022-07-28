#!/bin/bash

dataset_path="/mnt/nvme1/wr/dataset"

## Graph ingest time of XPGraph-B
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B start..." >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 16 --pblk_pools 32 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 16 --pblk_pools 32 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 16 --pblk_pools 32 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 16 --pblk_pools 32 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 16 --pblk_pools 64 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 16 --pblk_pools 64 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f ${dataset_path}/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --battery 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -f ${dataset_path}/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --battery 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B end." >> pmg.csv

mv pmg.csv script/csv/fig11_and_fig14/XPGraph-B.csv