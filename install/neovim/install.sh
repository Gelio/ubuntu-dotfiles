#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/.config
cd ~/.config
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

UPGRADE_ONLY=$(which nvim || true)

if [ -n "$UPGRADE_ONLY" ]; then
  nvim -v
  echo "Upgraded neovim, exiting"
  exit 0
fi

chmod u+x nvim.appimage
sudo ln -s "$PWD/nvim.appimage" /usr/bin/nvim

./stow.sh

# Install python3 provider for neovim
# See https://neovim.io/doc/user/provider.html
python3 -m pip install --user --upgrade pynvim

# xsel for clipboard support
# g++ for compiling Treesitter parsers
sudo apt install xsel g++

git config --global core.editor "nvim"
echo "export EDITOR=nvim" >>~/.profile
