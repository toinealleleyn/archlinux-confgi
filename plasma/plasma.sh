#!/bin/sh

# Dolphin file previews.
sudo pacman -S --needed --noconfirm kdegraphics-thumbnailers \
	qt5-imageformats \
	ffmpegthumbs \
	taglib

# Add emoji and cjk fonts.
sudo pacman -S --needed --noconfirm noto-fonts-{emoji,cjk}

# Install additional tools for basic functionality.
sudo pacman -S --needed --noconfirm spectacle \
	gwenview \
	okular 
