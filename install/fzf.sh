#!/bin/bash

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "If you are on Ubuntu and keybindings (e.g. Ctrl-T) are not working, see 'apt-cache show fzf'"
echo "You may have to add some lines to ~/.bashrc manually"
