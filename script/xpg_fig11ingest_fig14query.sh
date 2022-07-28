#!/bin/bash

## Graph ingest time of XPGraph
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Yahoo/bin32 -v 1413511394 --vbuf_pool 16 --pblk_pools 192 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Yahoo/bin32 -v 1413511394 --vbuf_pool 16 --pblk_pools 192 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 192 -q 1" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 192 -q 1
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph, end.\n\n" >> pmg.csv


## Graph ingest time of XPGraph-B
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Twitter/bin -v 61588415 --vbuf_pool 16 --pblk_pools 32 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Twitter/bin -v 61588415 --vbuf_pool 16 --pblk_pools 32 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Friendster/all/bin -v 68349467 --vbuf_pool 16 --pblk_pools 32 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Friendster/all/bin -v 68349467 --vbuf_pool 16 --pblk_pools 32 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Ukdomain/shuffle -v 105153953 --vbuf_pool 16 --pblk_pools 64 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Ukdomain/shuffle -v 105153953 --vbuf_pool 16 --pblk_pools 64 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -f /mnt/nvme1/wr/dataset/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --battery 1 -q 0" >> pmg.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size,[QueryTimings]:time_1hop(s),time_2hop(s),time_bfs(s),time_pagerank(s)" >> pmg.csv
for(( times = 0; times < 10; times++))
do
    echo "times = " $times " from echo"
    free -m
    sync; echo 1 > /proc/sys/vm/drop_caches
    free -m
    sleep 10s
    ./bin/main -f /mnt/nvme1/wr/dataset/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --battery 1 -q 0
done
echo >> pmg.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, end.\n\n" >> pmg.csv
