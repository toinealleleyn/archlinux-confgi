#!/bin/sh

# Script to install dash and configure as /bin/sh.

# Install dash.
sudo pacman -S --needed --noconfirm dash >/dev/null 2>&1

# Set as /bin/bsh and create pacman hook.
sudo ln -sfT dash /usr/bin/sh
sudo mkdir -p /etc/pacman.d/hooks/
sudo cp pacman.hook /etc/pacman.d/hooks/dashbinsh.hook
