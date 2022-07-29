#!/bin/bash

#
# !! Configure Optane to App-Direct Mode !! 
# !! Refer to scripts/nvdimm.md !!
#

export LD_LIBRARY_PATH=./src/api/lib/:$LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH = " $LD_LIBRARY_PATH

mkdir /pmem/wr/testGraphOne/
mkdir /mnt/pmem1/wr/testGraphOne/

mkdir results
mkdir results/fig11
mkdir results/fig12
mkdir results/fig14
mkdir results/fig15

# Figure 11 + Figure 14 + Figure 15
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-P performance, including Figure 11 (Graph ingest time cost for non-volatile systems), Figure 14 (Graph query performance)..." >> scripts/progress.txt
echo "[ Expected completion time: around 17.2 hours ]" >> scripts/progress.txt
bash scripts/GraphOne-P.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph performance, including Figure 11 (Graph ingest time cost for non-volatile systems), Figure 14 (Graph query performance), as well as Figure 15 (Graph recovery performance)..." >> scripts/progress.txt
echo "[ Expected completion time: around 12.9 hours ]" >> scripts/progress.txt
bash scripts/XPGraph.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-B performance, including Figure 11 (Graph ingest time cost for non-volatile systems)..." >> scripts/progress.txt
echo "[ Expected completion time: around 5.5 hours ]" >> scripts/progress.txt
bash scripts/XPGraph-B.sh
sleep 10s


# Figure 12
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-D performance in DRAM-Only system, including Figure 12 (Graph ingest time cost for volatile systems)..." >> scripts/progress.txt
echo "[ Expected completion time: around 1.2 hours ]" >> scripts/progress.txt
bash scripts/GraphOne-D-DO.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-D performance in DRAM-Only system, including Figure 12 (Graph ingest time cost for volatile systems)..." >> scripts/progress.txt
echo "[ Expected completion time: around 0.9 hours ]" >> scripts/progress.txt
bash scripts/XPGraph-D-DO.sh
# 
# !! Switch Optane to Memory Mode !! 
# !! Refer to scripts/nvdimm.md !!
# 
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-D performance under Memory Mode of Optane, including Figure 12 (Graph ingest time cost for volatile systems)..." >> scripts/progress.txt
echo "[ Expected completion time: around 6.6 hours ]" >> scripts/progress.txt
bash scripts/GraphOne-D-MM.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-D performance under Memory Mode of Optane, including Figure 12 (Graph ingest time cost for volatile systems)..." >> scripts/progress.txt
echo "[ Expected completion time: around 4.0 hours ]" >> scripts/progress.txt
bash scripts/XPGraph-D-MM.sh

# Figure 15
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-D performance, including Figure 15 (Graph recovery performance)..." >> scripts/progress.txt
echo "[ Expected completion time: around 1.6 hours ]" >> scripts/progress.txt
bash scripts/GraphOne-D-RE.sh
sleep 10s