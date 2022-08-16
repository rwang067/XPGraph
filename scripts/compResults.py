#!/usr/bin/python
import sys
from os.path import isfile
import math
import csv
import pandas as pd
import numpy as np

def compute_mean_time(path, col):
    """
    compute the average value of one column
    :param string path: the path of data file, column ID
    :return: float average value list
    """
    res = list()

    TT = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=2, nrows=10, usecols=[col], names=['time(s)'])
    res.append(TT['time(s)'].mean().round(2))
    FS = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=15, nrows=10, usecols=[col], names=['time(s)'])
    res.append(FS['time(s)'].mean().round(2))
    UK = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=28, nrows=10, usecols=[col], names=['time(s)'])
    res.append(UK['time(s)'].mean().round(2))
    K28 = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=41, nrows=10, usecols=[col], names=['time(s)'])
    res.append(K28['time(s)'].mean().round(2))
    YW = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=54, nrows=10, usecols=[col], names=['time(s)'])
    res.append(YW['time(s)'].mean().round(2))
    K29 = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=67, nrows=10, usecols=[col], names=['time(s)'])
    res.append(K29['time(s)'].mean().round(2))
    K30 = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=80, nrows=10, usecols=[col], names=['time(s)'])
    res.append(K30['time(s)'].mean().round(2))
    
    return res

def compute_mean_time_small(path, col):
    """
    compute the average value of one column
    :param string path: the path of data file, column ID
    :return: float average value list
    """
    res = list()

    TT = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=2, nrows=10, usecols=[col], names=['time(s)'])
    res.append(TT['time(s)'].mean().round(2))
    FS = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=15, nrows=10, usecols=[col], names=['time(s)'])
    res.append(FS['time(s)'].mean().round(2))
    UK = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=28, nrows=10, usecols=[col], names=['time(s)'])
    res.append(UK['time(s)'].mean().round(2))
    K28 = pd.read_csv(path, header=None, skipinitialspace=True, comment='#', skiprows=41, nrows=10, usecols=[col], names=['time(s)'])
    res.append(K28['time(s)'].mean().round(2))
    
    return res

def output_fig11(res_dir):
    GOP_file = res_dir + "/fig11/GraphOne-P.csv"
    XPG_file = res_dir + "/fig11/XPGraph.csv"
    XPGB_file = res_dir + "/fig11/XPGraph-B.csv"

    GOP = compute_mean_time(GOP_file, 0)
    XPG = compute_mean_time(XPG_file, 4)
    XPGB = compute_mean_time(XPGB_file, 4)

    f = open(res_dir + '/fig11/fig11_table.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-P')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\nXPGraph-B')
    for i in range(0, len(XPGB)):
        f.write(',' + str(XPGB[i]))
    f.write('\n')

def output_fig12(res_dir):
    GOD_file = res_dir + "/fig12/GraphOne-D-DO.csv"
    XPGD_file = res_dir + "/fig12/XPGraph-D-DO.csv"

    GOD = compute_mean_time_small(GOD_file, 0)
    XPGD = compute_mean_time_small(XPGD_file, 4)

    f = open(res_dir + '/fig12/fig12_table.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28\n')
    f.write('GraphOne-D-DO')
    for i in range(0, len(GOD)):
        f.write(',' + str(GOD[i]))
    f.write('\nXPGraph-D-DO')
    for i in range(0, len(XPGD)):
        f.write(',' + str(XPGD[i]))
    f.write('\n')

def output_fig12_MM(res_dir):
    GOD_file = res_dir + "/fig12/GraphOne-D-MM.csv"
    XPGD_file = res_dir + "/fig12/XPGraph-D-MM.csv"

    GOD = compute_mean_time(GOD_file, 0)
    XPGD = compute_mean_time(XPGD_file, 4)

    f = open(res_dir + '/fig12/fig12_MM_table.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-D-MM')
    for i in range(0, len(GOD)):
        f.write(',' + str(GOD[i]))
    f.write('\nXPGraph-D-MM')
    for i in range(0, len(XPGD)):
        f.write(',' + str(XPGD[i]))
    f.write('\n')

def output_fig14(res_dir):
    GOP_file = res_dir + "/fig14/GraphOne-P.csv"
    XPG_file = res_dir + "/fig14/XPGraph.csv"

    GOP = compute_mean_time(GOP_file, 0)
    XPG = compute_mean_time(XPG_file, 0)
    f = open(res_dir + '/fig14/fig14_table_hop1.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-P')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\n')

    GOP = compute_mean_time(GOP_file, 1)
    XPG = compute_mean_time(XPG_file, 1)
    f = open(res_dir + '/fig14/fig14_table_hop2.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-P')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\n')

    GOP = compute_mean_time(GOP_file, 2)
    XPG = compute_mean_time(XPG_file, 2)
    f = open(res_dir + '/fig14/fig14_table_bfs.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-P')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\n')

    GOP = compute_mean_time(GOP_file, 3)
    XPG = compute_mean_time(XPG_file, 3)
    f = open(res_dir + '/fig14/fig14_table_pagerank.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-P')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\n')

def output_fig15(res_dir):
    GOD_file = res_dir + "/fig15/GraphOne-D-RE.csv"
    XPG_file = res_dir + "/fig15/XPGraph.csv"

    GOP = compute_mean_time_small(GOD_file, 0)
    XPG = compute_mean_time(XPG_file, 0)

    f = open(res_dir + '/fig15/fig15_table.csv', "w")
    f.write('TimeCost(s),Twitter,Friendster,UKDomain,Kron28,YahooWeb,Kron29,Kron30\n')
    f.write('GraphOne-D')
    for i in range(0, len(GOP)):
        f.write(',' + str(GOP[i]))
    f.write('\nXPGraph')
    for i in range(0, len(XPG)):
        f.write(',' + str(XPG[i]))
    f.write('\n')

if __name__ == '__main__':
    # sys.argv = [res_dir]
    # e.g., python compResults.py ../results
    # Outputs: ../results/fig11/fig11_table.csv
    #          ../results/fig12/fig12_table.csv
    #          ../results/fig14/fig14_hop1_table.csv
    #          ../results/fig14/fig14_hop1_table.csv
    #          ../results/fig14/fig14_bfs_table.csv
    #          ../results/fig14/fig14_pagerank_table.csv
    #          ../results/fig14/fig15_table.csv
    res_dir = sys.argv[1]
    output_fig11(res_dir)
    output_fig12(res_dir)
    output_fig14(res_dir)
    output_fig15(res_dir)
    # output_fig12_MM(res_dir)