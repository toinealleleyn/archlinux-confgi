#!/bin/sh

# Check name of boot loader entry
ls /boot/loader/entries | grep arch.conf || (echo "Please rename boot entry to 'arch.conf'. Exiting" && exit)

# Install plymouth
sudo pacman -S --needed --noconfirm plymouth

# Add amdgpu modules to initrd
sudo sed -i 's/MODULES=()/MODULES=(amdgpu)/g' /etc/mkinitcpio.conf
# Add kms and plymooth hooks to initrd
sudo sed -i 's/block encrypt/block kms plymouth encrypt/g' /etc/mkinitcpio.conf
# Add quiet and splash to kernel params
grep "quiet splash" /boot/loader/entries/arch.conf || sudo sed -i '$s/$/ quiet splash/' /boot/loader/entries/arch.conf

# Set default theme
sudo tee /etc/plymouth/plymouthd.conf << EOF
[Daemon]
Theme=bgrt
EOF

# Build
sudo mkinitcpio -p linux
