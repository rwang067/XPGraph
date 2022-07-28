#!/bin/bash

export LD_LIBRARY_PATH=./src/api/lib/:$LD_LIBRARY_PATH
echo "LD_LIBRARY_PATH = " $LD_LIBRARY_PATH

echo "Test Figure 11 (Graph ingest time cost for XPGraph and XPGraph-B), as well as Figure 14 (Graph query performance for XPGraph)"  >> pmg.csv
bash xpg_fig11ingest_fig14query.sh
echo -e "\n"  >> pmg.csv
sleep 10s
