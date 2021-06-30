#!/bin/sh

# Script to configure Gnome to be more usable.

# Enable dark mode.
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Set keyboard layout.
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"

# Install CJK fonts (better than looking at squares).
sudo pacman -S --needed --noconfirm noto-fonts-cjk >/dev/null 2>&1

# Install extensions.
# Can be enabled after a re-login using gnome-extensions.
sudo pacman -S --needed --noconfirm libappindicator-gtk2 libappindicator-gtk3 \
	gnome-shell-extension-appindicator >/dev/null 2>&1
