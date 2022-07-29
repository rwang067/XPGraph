#!/bin/bash

## Graph ingest time of XPGraph-D under Memory Mode of Optane

pmem0="/pmem/wr/XPGraphDB/"
pmem1="/mnt/pmem1/wr/XPGraphDB/"
dataset_path="/mnt/nvme1/wr/dataset"

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Twitter/bin -v 61588415 --vbuf_pool 8 --pblk_pools 32 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Friendster/all/bin -v 68349467 --vbuf_pool 8 --pblk_pools 64 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Ukdomain/shuffle -v 105153953 --vbuf_pool 8 --pblk_pools 64 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron28/bin -v 268435456 --vbuf_pool 16 --pblk_pools 64 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Yahoo/bin32 -v 1413511394 --vbuf_pool 32 --pblk_pools 192 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron29/bin -v 536870912 --vbuf_pool 32 --pblk_pools 128 --dram_only 1
done
echo >> xpgraph_update.csv

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-B, with command: ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --dram_only 1" >> xpgraph_update.csv
echo "[UpdateTimings]: ingest_time(s),archive_count,archive_time(classify+buffer),flush_all_time(s),make_graph_time(s),[Memory]: vbuf_pool_size,pblk_pool_size," >> xpgraph_update.csv
for(( times = 0; times < 3; times++))
do
    echo "times = " $times " from echo"
    sleep 10s
    ./bin/main -j 0 -p0 $pmem0 -p1 $pmem1 -f ${dataset_path}/Kron30/bin -v 1073741824 --vbuf_pool 64 --pblk_pools 128 --dram_only 1
done
echo >> xpgraph_update.csv


cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Graph ingest time of XPGraph-D(Memory Mode), end." >> xpgraph_update.csv

mv xpgraph_update.csv results/fig12/XPGraph-D-MM.csv