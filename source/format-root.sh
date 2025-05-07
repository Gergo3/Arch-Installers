#!/bin/bash

#create pv and vg
vgcreate System $1

#create swap and root lvs
lvcreate -L 4G System -n Swap
lvcreate -l 100%FREE System -n Root
#free space for e2scrub
lvreduce -L -256M System/Root

#format lvs
mkfs.ext4 /dev/mapper/System-Root
mkswap /dev/mapper/System-Swap

#mount lvs
mount /dev/mapper/System-Root /mnt
swapon /dev/mapper/System-Swap
