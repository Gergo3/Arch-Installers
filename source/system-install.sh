#!/bin/bash
pacstrap -K $1 base base-devel linux linux-headers linux-firmware lvm2 networkmanager vim sudo bash-completion vi

genfstab -U $1 >> $1/etc/fstab
