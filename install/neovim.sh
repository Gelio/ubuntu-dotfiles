#!/bin/bash

CURRENT_DIR=$PWD
CONFIGS_DIR=$(dirname $PWD)/configs

mkdir -p ~/.config
cd ~/.config
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo ln -s "$PWD/nvim.appimage" /usr/bin/nvim

# Add symlink to config
mkdir -p nvim
ln -s "$CONFIGS_DIR/neovim.vim" nvim/init.vim

# xsel for clipboard support
# g++ for compiling Treesitter parsers
sudo apt install xsel g++

git config --global core.editor "nvim"
echo "export EDITOR=nvim" >> ~/.profile

cd $CURRENT_DIR
./vim-plug.sh
