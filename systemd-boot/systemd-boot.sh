#!/bin/sh

# Script to configure systemd-boot.

# Create pacman hook to update systemd-boot after the systemd package upgrades.
sudo mkdir -p /etc/pacman.d/hooks/
sudo cp pacman.hook /etc/pacman.d/hooks/100-systemd-boot.hook
