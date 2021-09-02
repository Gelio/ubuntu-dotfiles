#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/.config
wget -O ~/.config/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

upgrade_only=$(command -v nvim || true)

if [ -n "$upgrade_only" ]; then
  nvim -v
  echo "Upgraded neovim, exiting"
  exit 0
fi

chmod u+x ~/.config/nvim.appimage
sudo ln -s "$HOME/.config/nvim.appimage" /usr/bin/nvim

./stow.sh

# Install python3 provider for neovim
# See https://neovim.io/doc/user/provider.html
python3 -m pip install --user --upgrade pynvim

# xsel for clipboard support
# g++ for compiling Treesitter parsers
sudo apt install xsel g++
