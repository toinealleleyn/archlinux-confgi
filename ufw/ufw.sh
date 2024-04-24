#!/bin/sh

# Install ufw and replace iptables with nftables
sudo pacman -S --needed --noconfirm ufw iptables-nft

# Default deny, and enable
sudo ufw default deny
sudo ufw enable
sudo systemctl enable --now ufw.service
