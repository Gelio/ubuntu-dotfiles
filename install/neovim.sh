#!/bin/bash

mkdir -p ~/.config
cd ~/.config
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo ln -s "$PWD/nvim.appimage" /usr/bin/nvim
mkdir -p nvim
echo "set relativenumber\
set number" >> init.vim

# Necessary for clipboard support
sudo apt install xsel

git config --global core.editor "nvim"
