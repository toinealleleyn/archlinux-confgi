#!/bin/bash

# Install neovim
sudo pacman -S --noconfirm --needed neovim

# Create config directory
mkdir -p ${HOME}/.config/nvim

# Create init.vim file
tee ${HOME}/.config/nvim/init.vim << EOF
set relativenumber
hi LineNr ctermfg=8

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
EOF
