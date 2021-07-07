#!/bin/sh

# Script to install newsboat with my config and urls.

# Install newsboat.
sudo pacman -S --needed --noconfirm newsboat >/dev/null 2>&1

# Deploy config files.
mkdir -p $HOME/.newsboat
cp config $HOME/.newsboat/config
cp urls $HOME/.newsboat/urls
