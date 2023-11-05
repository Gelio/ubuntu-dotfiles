#!/usr/bin/env bash
set -euxo pipefail

destination_dir=~/.local/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git "$destination_dir"
cd "$destination_dir"
./install

echo "If you are on Ubuntu and keybindings (e.g. Ctrl-T) are not working, see 'apt-cache show fzf'"
echo "You may have to add some lines to ~/.bashrc manually"
