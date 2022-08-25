#!/bin/sh

# Install zsh.
sudo pacman -S --needed --noconfirm zsh zsh-syntax-highlighting

# Set as default shell.
sudo chsh -s $(which zsh) $(whoami)

# Create zprofile and zshrc.
mkdir -p $HOME/.config/zsh 
mkdir -p $HOME/.cache/zsh
cp zprofile $HOME/.config/zsh/.zprofile
ln -s $HOME/.config/zsh/.zprofile $HOME/.zprofile >/dev/null 2>&1
ln -s $HOME/.config/zsh/.zprofile $HOME/.xprofile >/dev/null 2>&1
cp zshrc $HOME/.config/zsh/.zshrc
