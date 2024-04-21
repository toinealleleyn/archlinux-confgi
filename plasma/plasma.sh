#!/bin/sh

# Dolphin file previews.
sudo pacman -S --needed --noconfirm kdegraphics-thumbnailers \
	kimageformats \
	libheif \
	qt6-imageformats \
	ffmpegthumbs \
	taglib

# Add emoji and cjk fonts.
sudo pacman -S --needed --noconfirm noto-fonts-{emoji,cjk}

# Install additional tools for basic functionality.
sudo pacman -S --needed --noconfirm spectacle \
	gwenview \
	okular 

# Fix breeze cursor not showing in GTK apps.
sudo sed -i 's/Adwaita/breeze_cursors/g' /usr/share/icons/default/index.theme
