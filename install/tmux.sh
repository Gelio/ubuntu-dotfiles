#!/bin/bash

CONFIGS_DIR=$(dirname $PWD)/configs

sudo apt install tmux
ln -s $CONFIGS_DIR/tmux.conf ~/.tmux.conf

echo "For tmux bottom bar to work correctly, powerline icons are required"
if grep -qi Microsoft /proc/version; then
	echo "Looks like you're on WSL"
	echo "1. Install a font that has powerline symbols"
	echo "   Choose one from https://www.nerdfonts.com/font-downloads"
	echo "   e.g. FiraCode NF"
	echo "2. Select that font as the default font in your terminal"
	echo "   e.g. in Windows Terminal, set fontFamily: FiraCode NF"
	echo "3. (optional) Adjust fontSize, as it probably is a bit too large"
	echo "   11 should be ok"
else
	echo "Detected regular system (not WSL), installing through apt"
	sudo apt install powerline
	echo "Done"
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Do 'Ctrl + b I' in tmux to install the plugins"

echo "Installing tmux completions"
source ./bash-completions-dir.sh
COMPLETIONS_PATH=$BASH_COMPLETIONS_DIR/tmux.bash
wget -qO $COMPLETIONS_PATH https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux
echo "Completions saved to $COMPLETIONS_PATH " 
