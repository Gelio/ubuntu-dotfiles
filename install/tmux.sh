#!/bin/bash

CONFIGS_DIR=$(dirname $PWD)/configs

sudo apt install tmux
ln -s $CONFIGS_DIR/tmux.conf ~/.tmux.conf

echo "Installing powerline for tmux bottom bar to work correctly"
sudo apt install powerline
echo "Done"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Do 'Ctrl + b I' in tmux to install the plugins"

echo "Installing tmux completions"
source ./bash-completions-dir.sh
COMPLETIONS_PATH=$BASH_COMPLETIONS_DIR/tmux.bash
wget -qO $COMPLETIONS_PATH https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux
echo "Completions saved to $COMPLETIONS_PATH " 
