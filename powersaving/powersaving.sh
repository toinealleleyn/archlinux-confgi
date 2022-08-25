#!/bin/sh

# Script to configure powersaving with default settings.
# tlp, tlp-rdw and powertop

# Install packages.
sudo pacman -S --needed --noconfirm tlp tlp-rdw

# Configure the services.
sudo systemctl enable tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
