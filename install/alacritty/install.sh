#!/usr/bin/env bash

set -euo pipefail

# https://stackoverflow.com/a/13864829
if [ -z "${COMPLETIONS_ONLY+x}" ]; then
  sudo add-apt-repository ppa:aslatter/ppa
  sudo apt install alacritty

  ./stow.sh

  echo "If you're on Ubuntu, add 'wmctrl -a alacritty' keyboard shortcut"
fi

echo "Adding bash completions for the latest release"
source ../bash-completions-dir.sh
alacritty_bash_completions_url=https://github.com/alacritty/alacritty/releases/latest/download/alacritty.bash
completions_path=$BASH_COMPLETIONS_DIR/alacritty.bash
wget -qO "$completions_path" $alacritty_bash_completions_url

echo "Completions saved to $completions_path"
