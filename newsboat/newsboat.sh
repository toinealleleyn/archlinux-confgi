#!/bin/sh

# Script to install newsboat with my config and urls.

# Install newsboat.
sudo pacman -S --needed --noconfirm newsboat >/dev/null 2>&1

# Install packages used in macro's.
sudo pacman -S --needed --noconfirm youtube-dl mpv >/dev/null 2>&1

# Deploy config files.
mkdir -p $HOME/.newsboat
cp config $HOME/.newsboat/config
cp urls $HOME/.newsboat/urls
mkdir -p $HOME/.config/systemd/user
cp systemd.service $HOME/.config/systemd/user/newsboat.service
cp systemd.timer $HOME/.config/systemd/user/newsboat.timer

# Enable service
systemctl --user daemon-reload
systemctl --user enable newsboat.service --now
systemctl --user enable newsboat.timer --now
