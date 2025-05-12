#!/bin/bash
pacstrap -K $1 base base-devel linux linux-headers linux-firmware cryptestup lvm2 networkmanager vim sudo bash-completion vi

genfstab -U $1 >> $1/etc/fstab

arch-chroot $1 hwclock --systohc

sed 's/"^#en_US\.UTF-8 UTF-8"/"en_US.UTF-8 UTF-8"/' $1/etc/locale.gen > $1/etc/locale.gen

arch-chroot $1 locale-gen

if [ ! $(grep '^HOOKS=(base udev' | grep 'keyboard') ]; then sed '/"^HOOKS=(base udev"/s/kms/"kms keyboard"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi
if [ ! $(grep '^HOOKS=(base udev' | grep 'keymap') ]; then sed '/"^HOOKS=(base udev"/s/keyboard/"keyboard keymap"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi
if [ ! $(grep '^HOOKS=(base udev' | grep 'consolefont') ]; then sed '/"^HOOKS=(base udev"/s/keymap/"keymap consolefont"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi
if [ ! $(grep '^HOOKS=(base udev' | grep 'mdadm_udev') ]; then sed '/"^HOOKS=(base udev"/s/block/"block mdadm_udev"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi
if [ ! $(grep '^HOOKS=(base udev' | grep 'encrypt') ]; then sed '/"^HOOKS=(base udev"/s/mdadm_udev/"mdadm_udev encrypt"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi
if [ ! $(grep '^HOOKS=(base udev' | grep 'lvm2') ]; then sed '/"^HOOKS=(base udev"/s/encrypt/"encrypt lvm2"' $1/etc/mkinitcpio.conf > $1/etc/mkinitcpio.conf; fi

arch-chroot $1 mkinitcpio -P

