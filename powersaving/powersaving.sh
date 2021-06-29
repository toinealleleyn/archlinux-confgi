#!/bin/sh

# Script to configure powersaving with default settings.
# tlp, tlp-rdw and powertop

# Install packages.
sudo pacman -S --needed --noconfirm tlp tlp-rdw powertop

# Create systemd service for powertop (auto-tune).
sudo cp powertop.service /etc/systemd/system/powertop.service

# Configure the services.
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
sudo systemctl enable powertop.service

