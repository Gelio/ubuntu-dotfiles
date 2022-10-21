#!/usr/bin/env bash

set -euo pipefail

pushd ~/.local/ >/dev/null
if [[ -d tmux ]]; then
  cd tmux
  echo "tmux repository found, pulling latest changes"
  git pull
else
  echo "tmux repository not found, cloning it for the first time"
  git clone git@github.com:tmux/tmux.git
  cd tmux

  # https://github.com/tmux/tmux/wiki/Installing#from-source-tarball
  echo "Installing build dependencies"
  sudo apt install libevent-devel
fi
echo "Compiling tmux"
sh autogen.sh
./configure && make && sudo make install
popd >/dev/null

./stow.sh

echo "> For tmux bottom bar to work correctly, powerline icons are required"
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
  echo "> Detected regular system (not WSL), installing through apt"
  sudo apt install powerline
  echo "> Done"
fi

printf "\n\n"

[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Do 'Ctrl + b I' in tmux to install the plugins"

source ../bash-completions-dir.sh
completions_path=$BASH_COMPLETIONS_DIR/tmux.bash

if [ -f "$completions_path" ]; then
  echo "Completions alredy installed"
else
  echo "Installing tmux completions"
  wget -qO "$completions_path" https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux
  echo "Completions saved to $completions_path"
fi
