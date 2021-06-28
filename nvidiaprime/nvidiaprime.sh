#!/bin/sh

# Script to configure NVIDIA PRIME to manage hybrid graphics.
# This will install the closed-source NVIDIA drivers.

# Install required packages.
sudo pacman -S --needed --noconfirm nvidia nvidia-prime
	
# Create udev rules.
sudo cp udev.rules /etc/udev/rules.d/80-nvidia-pm.rules

# Enable power management, settings are:
# 0x00 = Disable runtime D3 power management features.
# 0x01 = NVIDIA GPU will go into its lowest power state when no
#	 applications are using the driver stack.
# 0x02 = NVIDIA GPU will be powered down if the GPU is not used
#	 for a short period, and powered on if application starts
#	 using the GPU.
PMSETTING="0x02"
echo "options nvidia "NVreg_DynamicPowerManagement=$PMSETTING"" \
	| sudo tee /etc/modprobe.d/nvidia.conf
