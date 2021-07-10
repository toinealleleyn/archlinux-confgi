#!/bin/sh

# Install zsh.
sudo pacman -S --needed --noconfirm zsh zsh-syntax-highlighting >/dev/null 2>&1

# Install packages used in aliases (to make the script usable standalone).
sudo pacman -S --needed --noconfirm neovim youtube-dl mpv >/dev/null 2>&1

# Set as default shell.
sudo chsh -s $(which zsh) $(whoami) >/dev/null 2>&1

# Create zprofile and zshrc.
mkdir -p $HOME/.config/zsh 
mkdir -p $HOME/.cache/zsh
cp zprofile $HOME/.config/zsh/.zprofile
ln -s $HOME/.config/zsh/.zprofile $HOME/.zprofile >/dev/null 2>&1
ln -s $HOME/.config/zsh/.zprofile $HOME/.xprofile >/dev/null 2>&1
cp zshrc $HOME/.config/zsh/.zshrc

# Add icon support for lf.
cp lficons $HOME/.config/zsh/.lficons
