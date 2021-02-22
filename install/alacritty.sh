#!/bin/bash

# https://stackoverflow.com/a/13864829
if [ -z "${COMPLETIONS_ONLY+x}" ]; then
    sudo add-apt-repository ppa:aslatter/ppa
    sudo apt install alacritty

    CONFIGS_DIR=$(dirname $PWD)/configs

    mkdir -p ~/.config/alacritty
    ln -s "$CONFIGS_DIR/alacritty.yml" ~/.config/alacritty/alacritty.yml

    echo "If you're on Ubuntu, add 'wmctrl -a alacritty' keyboard shortcut"
fi

echo "Adding bash completions for the latest release"
source ./bash-completions-dir.sh
ALACRITTY_BASH_COMPLETIONS_URL=https://github.com/alacritty/alacritty/releases/latest/download/alacritty.bash
COMPLETIONS_PATH=$BASH_COMPLETIONS_DIR/alacritty.bash
wget -qO $COMPLETIONS_PATH $ALACRITTY_BASH_COMPLETIONS_URL

echo "Completions saved to $COMPLETIONS_PATH"
