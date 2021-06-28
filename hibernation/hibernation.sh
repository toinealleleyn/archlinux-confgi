#!/bin/sh

# Script to enable hibernation using a swapfile.

# Install bc for extra calculations.
sudo pacman -S --needed --noconfirm bc >/dev/null 2>&1

# Determine size the swapfile needs to be.
# Based on the sum of the total memory and the square root of the total memory.
HIBERNATIONSIZE=$(grep MemTotal /proc/meminfo | awk -F ' ' '{print $2}' | awk '{$1=$1/1024; print ($0-int($0)>0)?int($0)+1:int($0)}')
EXTRASWAPSIZE=$(echo "$HIBERNATIONSIZE" | awk '{$1=$1/1024; print ($0-int($0)>0)?int($0)+1:int($0)}' | \
	(read EXTRASWAPSIZE; echo "scale=3;sqrt($EXTRASWAPSIZE)") | bc | awk '{$1=$1*1024; print ($0-int($0)>0)?int($0)+1:int($0)}')
TOTALSWAPSIZE=$(($HIBERNATIONSIZE+$EXTRASWAPSIZE))

# Create swapfile.
sudo dd if=/dev/zero of=/swapfile bs=1M count=$TOTALSWAPSIZE >/dev/null 2>&1

# Format to swap and activate.
sudo chmod 600 /swapfile
sudo mkswap /swapfile >/dev/null 2>&1
sudo swapon /swapfile >/dev/null 2>&1

# Add swapfile to /etc/fstab.
grep "/swapfile" /etc/fstab >/dev/null 2>&1 || \
	echo "/swapfile\t\tnone\t\tswap\t\tdefaults\t\t0 0" | sudo tee -a /etc/fstab >/dev/null 2>&1

# Configure kernel parameters.
SWAPDEVICE=$(findmnt -no UUID -T /swapfile)
SWAPFILEOFFSET=$(sudo filefrag -v /swapfile | awk '{ if($1=="0:"){print substr($4, 1, length($4)-2)} }')

# Manual action to enable hibernation.
echo "Add the following (after the root parameter) to the kernel parameters:"
echo "'resume=UUID=$SWAPDEVICE resume_offset=$SWAPFILEOFFSET'\n"
echo "Add 'resume' after filesystem (and lvm2) in /etc/mkinitcpio.conf."
echo "Run 'sudo mkinitcpio -p linux' afterwards. Reboot, done."
