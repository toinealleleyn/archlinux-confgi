#!/bin/sh

# Install ufw.
sudo pacman -S --needed --noconfirm ufw

# Default deny, and enable
sudo ufw default deny
sudo ufw enable
sudo systemctl enable --now ufw.service
