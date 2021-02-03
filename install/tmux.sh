#!/bin/bash

CONFIGS_DIR=$(dirname $PWD)/configs

sudo apt install tmux
ln -s $CONFIGS_DIR/tmux.conf ~/.tmux.conf

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Do 'Ctrl + b I' in tmux to install the plugins"
