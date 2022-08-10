## GraphOne-D and GraphOne-P
We take GraphOne, the state-of-the-art single-machine in-memory graph storage system, as a baseline for overall performance comparison. Here we provide two versions of GraphOne, i.e., (1) the original GraphOne (abbreviated as GraphOne-D) that stores all data on DRAM. (2) PMEM-based GraphOne (abbreviated as GraphOne-P) which stores the edge log and adjacency lists on PMEM by mmap-based implementation and keeps the meta-data and the intermediate data on DRAM. 

### System Configuration
Note that GraphOne-P runs on ext4-dax file system, so you should mount pmem in ext4-dax with the following commands.
```bash
mkfs.ext4 -b 4096 -E stride=512 -F ${device_path_0}
mkfs.ext4 -b 4096 -E stride=512 -F ${device_path_1}

mount -o dax ${device_path_0} *path_to_pmem0*
mount -o dax ${device_path_1} *path_to_pmem1*
```

### Building
You can run following command to build GraphOne-D. Refer to https://github.com/ZoRax-A5/GraphOne/blob/master/README.md for detailed description. For the sake of comparision, we just modified program output based on the original GraphOne.
```bash
$ git clone https://github.com/ZoRax-A5/GraphOne.git
$ mkdir build
$ cd build
$ cmake ../
$ make
```

Before you build GraphOne-P, we will install libpmem on your machine. The way to build GraphOne-P is similar to build GraphOne-D. 
```bash
## TODO install libpmem
$ git clone https://github.com/ZoRax-A5/GraphOne.git -b PMGraphOne
$ mkdir build
$ cd build
$ cmake ../
$ make
```

### Running

To run test on the baseline, you can refer to https://github.com/ZoRax-A5/GraphOne/blob/master/README.md for related command-line options. Note that for GraphOne-P, We add two additional options to specific path for pmem. 
```bash
 -a: path for pmem0
 -b: path for pmem1
```

**Example1: Ingest all edges in Friendster dataset(directed, binary input) on GraphOne-D.**

```bash
$ cd baselines/GraphOne-D
$ ./build/graphone32 -i ./Dataset/Friendster/xx -v 68349467 -j 0 -s 1 -d 1 -t 16

```

**Example2: Ingest all edges in Friendster dataset(directed, binary input) on GraphOne-P, and then execute each implemanted graph algorithm one time.**

```bash
$ cd baselines/GraphOne-P
$ ./build/graphone32 -i ./Dataset/Friendster/xx -v 68349467 -j 0 -s 1 -d 1 -t 16 -a *path_to_pmem0*/XPGraphDB0/ -b *path_to_pmem1*/XPGraphDB1/
```

## GraphOne-NOVA

We provide a guideline to build and run GraphOne based on NOVA file system (abbreviated as GraphOne-N), which stores the adjacency lists on PMEM by file-I/O-based implementation. First you need to build and install a version of the Linux with NOVA included. Then create a NOVA instance and mount it on your host. Finally compile and run GraphOne-N and then you can test on this baseline.

### Building NOVA

Generally speaking, you can build and install NOVA just as you would the mainline Linux source.  Just notice build with  `LIBNVDIMM`, `PMEM`, `DAX` and `NOVA` support. 

```bash
## Downloads and config NOVA
$ git clone https://github.com/NVSL/linux-nova.git
$ cd linux-nova
$ make menuconfig
```

Then you can set those options as below.

```bash
Device Drivers  --->
        <*> NVDIMM (Non-Volatile Memory Device) Support  --->
            <*>   PMEM: Persistent memory block device support (NEW)
            <*>   BLK: Block data window (aperture) device support (NEW)
            [*]   BTT: Block Translation Table (atomic sector updates)
    Processor type and features  --->
        <*> Support non-standard NVDIMMs and ADR protected memory
    Memory Management options  --->
        [*] Allow for memory hot-add
        [*]   Online the newly added memory blocks by default
        [*]   Allow for memory hot remove
        [*] Device memory (pmem, HMM, etc...) hotplug support
    File systems  --->
        [*] Direct Access (DAX) support
```

After config, build and install kernel with the following commands:

```bash
## build kernel with nova modules
make -j4
make modules_install
make install
```

### Using NOVA

Reboot the system and boot into the correct kernel with the NOVA module. After the OS has booted, you can initialize a NOVA instance that configs in relaxed mode with the following commands:

```bash
## config in relaxed mode
$ modprobe nova metadata_csum=0\
  	       data_csum=0\
	       data_parity=0\
	       wprotect=0\
           inplace_data_updates=1
$ mount -t NOVA -o init ${device_path_0} ${pmem0_path}
$ mount -t NOVA -o init ${device_path_1} ${pmem1_path}
$ ...
```

> Nova support several module command line options: 
>
> * metadata_csum: Enable metadata replication and checksums (default 0)
> * data_csum: Compute checksums on file data. (default: 0)
> * data_parity: Compute parity for file data. (default: 0)
> * inplace_data_updates:  Update data in place rather than with COW (default: 0)
> * wprotect: Make PMEM unwritable and then use CR0.WP to enable writes as needed (default: 0).  You must also install the nd_pmem module as with wprotect =1 (e.g., modprobe nd_pmem readonly=1).

Finally, download and build GraphOne-N with the following commands:

```bash
$ git clone https://github.com/ZoRax-A5/GraphOne.git -b gova
$ mkdir build
$ cd build
$ cmake ../
$ make
```

For linux-nova configuration, refer to https://github.com/NVSL/linux-nova/blob/master/Documentation/filesystems/nova.txt for detailed description.
