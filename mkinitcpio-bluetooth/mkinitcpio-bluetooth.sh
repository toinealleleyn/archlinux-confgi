#!/bin/sh

# Check if configuration is compatible
grep -q 'systemd' /etc/mkinitcpio.conf && echo "Error: mkinitcpio-bluetooth not compatible with the systemd hook (/etc/mkinitcpio.conf)" && exit 

# Install mkinitcpio-bluetooth
paru -S --needed mkinitcpio-bluetooth

# Enable bluetooth auto enable
sudo sed -i 's/^#AutoEnable=true/AutoEnable=true/g' /etc/bluetooth/main.conf 

# Add bluetooth to mkinitcpio
sudo sed -i 's/block encrypt/block bluetooth encrypt/g' /etc/mkinitcpio.conf