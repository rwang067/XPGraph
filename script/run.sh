#!/bin/bash

# !! Configure Optane to App-Direct Mode !! 

export LD_LIBRARY_PATH=./src/api/lib/:$LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH = " $LD_LIBRARY_PATH

mkdir results

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time 
echo "Test Figure 11 (Graph ingest time cost for non-volatile systems), as well as Figure 14 (Graph query performance)..."  >> script/progress.txt
mkdir results/fig11_and_fig14
bash script/fig11_and_fig14/GraphOne-D.sh
bash script/fig11_and_fig14/GraphOne-P.sh
bash script/fig11_and_fig14/XPGraph.sh
bash script/fig11_and_fig14/XPGraph-B.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time 
echo "Test Figure 15 (Graph recovery performance)..."  >> script/progress.txt
mkdir results/fig15
bash script/fig15/GraphOne-D.sh
bash script/fig15/XPGraph.sh
sleep 10s

cur_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $cur_time 
echo "Test Figure 12 (Graph ingest time cost for volatile systems)..."  >> script/progress.txt
mkdir results/fig12
bash script/fig12/GraphOne-D-DO.sh
bash script/fig12/XPGraph-D-DO.sh
# !! Switch Optane to Memory Mode !! 
bash script/fig12/GraphOne-D-MM.sh
bash script/fig12/XPGraph-D-MM.sh
sleep 10s