#!/bin/sh

# Install AppArmor
sudo pacman -S --noconfirm --needed apparmor

# Enable service to load profiles
sudo systemctl enable --now apparmor.service

# Enable AppArmor as default security model
echo "Add the following kernel parameter:"
echo '"lsm=landlock,lockdown,yama,integrity,apparmor,bpf"'
