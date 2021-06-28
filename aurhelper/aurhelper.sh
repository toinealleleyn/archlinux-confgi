#!/bin/sh

# Script to install an AUR helper.
# Default: paru. Change variable AURHELPER for a different helper. 
AURHELPER="paru"
AURURL="https://aur.archlinux.org/cgit/aur.git/snapshot/$AURHELPER.tar.gz"

# Install dependencies.
sudo pacman -S --needed --noconfirm base-devel git >/dev/null 2>&1

# Configure makepkg to use all cores for compilation.
grep "MAKEFLAGS=\"-j$(nproc)\"" /etc/makepkg.conf >/dev/null 2>&1 || \
	sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Download and build the AUR helper.
[ -f "/usr/bin/$AURHELPER" ] || (
	cd /tmp || exit 1
	rm -rf /tmp/"$AURHELPER"*
	curl -sO "$AURURL" &&
	tar -xvf "$AURHELPER".tar.gz >/dev/null 2>&1 &&
	cd "$AURHELPER" &&
	makepkg --noconfirm -si || echo "Failed."
	cd /tmp
	rm -rf /tmp/"$AURHELPER"* )
