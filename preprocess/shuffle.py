#!/usr/bin/python
import os
import random
import sys
import getopt

if __name__ == '__main__':
    inputfile = ''
    outputfile = ''
    nverts = 0
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hi:o:v:",["ifile=","ofile=","nverts="])
    except getopt.GetoptError:
        print('shuffle.py -i <inputfile> -o <outputfile> -v <nverts>')
        sys.exit(3)
    for opt, arg in opts:
        if opt == '-h':
            print('shuffle.py -i <inputfile> -o <outputfile> -v <nverts>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-v", "--nverts"):
            nverts = int(arg)

    print('input file:', inputfile)
    print('output file:', outputfile)
    print('nverts:', nverts)
    
    out = open(outputfile, 'a+')
    lines = []
    idx = 0
    slice = 100000000 if nverts // 10 > 100000000 else nverts // 10

    with open(inputfile) as infile:
        for line in infile:
            lines.append(line)
            idx += 1
            if idx % slice == 0:
                random.shuffle(lines)
                for line in lines:
                    out.write(line)
                lines = []

        
    if lines != []:
        random.shuffle(lines)
        for line in lines:
            out.write(line)

