#!/bin/bash

# Install neovim
sudo pacman -S --noconfirm --needed neovim

# Create config directory
mkdir -p $HOME/.config/nvim

# Create files
touch $HOME/.config/nvim/init.vim
mkdir $HOME/.config/nvim/vim-plug
touch $HOME/.config/nvim/vim-plug/plugins.vim

# Install and configure vim-plug
tee $HOME/.config/nvim/vim-plug/plugins.vim << EOF
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'

    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'

call plug#end()
EOF

tee $HOME/.config/nvim/relativenumber.vim << EOF
set relativenumber
hi LineNr ctermfg=8
EOF

# Create init.vim file
echo "source \$HOME/.config/nvim/vim-plug/plugins.vim" > $HOME/.config/nvim/init.vim
echo "source \$HOME/.config/nvim/relativenumber.vim" >> $HOME/.config/nvim/init.vim
