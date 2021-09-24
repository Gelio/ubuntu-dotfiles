#!/usr/bin/env bash
set -euo pipefail

nvim_version=${1:-nightly}
directory_name="nvim-linux64"
archive_name="$directory_name.tar.gz"
upgrade_only=$(command -v nvim || true)

function main {
  echo "* Downloading $nvim_version"
  wget "https://github.com/neovim/neovim/releases/download/$nvim_version/$archive_name"

  stow_package -D

  tar -xzf "$archive_name"
  rm "$archive_name"

  echo "* Installing via stow"
  stow_package

  nvim -v

  if [ -n "$upgrade_only" ]; then
    echo "Upgraded neovim, exiting"
    exit 0
  fi

  install
}

function install {
  ./stow.sh

  # Install python3 provider for neovim
  # See https://neovim.io/doc/user/provider.html
  python3 -m pip install --user --upgrade pynvim

  # xsel for clipboard support
  # g++ for compiling Treesitter parsers
  sudo apt install xsel g++
}

function stow_package {
  sudo stow --no-folding -t /usr "$@" $directory_name
}

main
