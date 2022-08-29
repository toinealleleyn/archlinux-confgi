#!/bin/sh

# Script to configure NVIDIA PRIME to manage hybrid graphics.
# This will install the closed-source NVIDIA drivers.

# Install required packages.
sudo pacman -S --needed --noconfirm xf86-video-intel nvidia nvidia-prime
	
# Create udev rules.
sudo tee /etc/udev/rules.d/80-nvidia-pm.rules << EOF
# Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

# Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
EOF

# Enable power management, settings are:
# 0x00 = Disable runtime D3 power management features.
# 0x01 = NVIDIA GPU will go into its lowest power state when no
#	 applications are using the driver stack.
# 0x02 = NVIDIA GPU will be powered down if the GPU is not used
#	 for a short period, and powered on if application starts
#	 using the GPU.
PMSETTING="0x02"
sudo tee /etc/modprobe.d/nvidia.conf << EOF
blacklist nouveau
options nvidia "NVreg_DynamicPowerManagement=$PMSETTING"
EOF

# Enable nvidia-resume for faster resume after sleep.
sudo systemctl enable --now nvidia-resume.service