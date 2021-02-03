#!/bin/bash

sudo add-apt-repository ppa:aslatter/ppa
sudo apt install alacritty

CONFIGS_DIR=$(dirname $PWD)/configs

mkdir -p ~/.config/alacritty
ln -s "$CONFIGS_DIR/alacritty.yml" ~/.config/alacritty/alacritty.yml

echo "If you're on Ubuntu, add 'wmctrl -a alacritty' keyboard shortcut"
