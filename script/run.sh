#!/bin/bash

#
# !! Configure Optane to App-Direct Mode !! 
# !! Refer to script/nvdimm.md !!
#

export LD_LIBRARY_PATH=./src/api/lib/:$LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH = " $LD_LIBRARY_PATH

mkdir results
mkdir results/fig11
mkdir results/fig12
mkdir results/fig14
mkdir results/fig15

# Figure 11 + Figure 14 + Figure 15
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-P performance, including Figure 11 (Graph ingest time cost for non-volatile systems), Figure 14 (Graph query performance), as well as Figure 15 (Graph recovery performance)..." >> script/progress.txt
bash script/GraphOne-P.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph performance, including Figure 11 (Graph ingest time cost for non-volatile systems), Figure 14 (Graph query performance), as well as Figure 15 (Graph recovery performance)..." >> script/progress.txt
bash script/XPGraph.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-B performance, including Figure 11 (Graph ingest time cost for non-volatile systems)..." >> script/progress.txt
bash script/XPGraph-B.sh
sleep 10s


# Figure 12
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-D performance in DRAM-Only system, including Figure 12 (Graph ingest time cost for volatile systems)..." >> script/progress.txt
bash script/GraphOne-D-DO.sh
sleep 10s
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-D performance in DRAM-Only system, including Figure 12 (Graph ingest time cost for volatile systems)..." >> script/progress.txt
bash script/XPGraph-D-DO.sh
# 
# !! Switch Optane to Memory Mode !! 
# !! Refer to script/nvdimm.md !!
# 
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test GraphOne-D performance under Memory Mode of Optane, including Figure 12 (Graph ingest time cost for volatile systems)..." >> script/progress.txt
bash script/GraphOne-D-MM.sh
sleep 10s
cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time "Test XPGraph-D performance under Memory Mode of Optane, including Figure 12 (Graph ingest time cost for volatile systems)..." >> script/progress.txt
bash script/XPGraph-D-MM.sh
