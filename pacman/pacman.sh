#!/bin/sh

# Add color to pacman.
sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf

# Enable parallel downloads.
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

# Install reflector.
sudo pacman -S --needed --noconfirm reflector
sudo sed -i 's/^# --country France,Germany/--country Netherlands/g' /etc/xdg/reflector/reflector.conf
