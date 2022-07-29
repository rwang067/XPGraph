# NVDIMM 学习

## PM 配置 Memory Mode

在内存模式下，PM 模块作为系统内存被操作系统控制，任何 DDR 都作为 PM 模块的 cache。

首先，查看系统当前 DIMM 设备的情况

```bash
ipmctl show -topology
ipmctl show -socket
ipmctl show -dimm 
ipmctl show -memoryresources
```

如果 PM 已经预先配置了其他模式，则需要先清除现有模式。

```bash
ndctl list -iN
ndctl destroy-namespace -f all
ipmctl delete -goal
sudo systemctl reboot
```

配置当前 PMEM 为 memory mode。

```bash
ipmctl create -goal MemoryMode=100
```

另外需要恢复成 APP-Direct 模式。首先，清除已有 goal，并设置为 appdirect

```bash
ipmctl delete -goal
ipmctl create -goal PersistentMemoryType=AppDirect
systemctl reboot
```

重启后，查看设备情况，并创建新的 namespace，直到所有空间分配结束。

```bash
ndctl list -R
ndctl create-namespace --mode=fsdax # run N times
```

运行 `ndctl list` ，观察到新的 blockdev 已经成功分配。最后，使用 dax 进行文件系统挂载，挂载 pmem 文件夹。

```bash
mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem0
sudo mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem1

sudo mount -o dax /dev/pmem0 /pmem
sudo mount -o dax /dev/pmem1 /mnt/pmem1

df -lh
```

