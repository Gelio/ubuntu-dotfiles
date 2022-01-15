#!/usr/bin/env bash
set -euo pipefail

# Allows running the script from any directory
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
pushd "$script_dir" >/dev/null

function main {
  pushd ~/.local >/dev/null
  if [[ -d neovim ]]; then
    cd neovim
    echo "* neovim repository found at $PWD, pulling latest changes..."
    # Pulling fails most likely when a hash is checked out, not a branch.
    # This is normal when there are breaking changes on master and a previous
    # commit is used to build neovim.
    git pull || echo "Pulling latest changes failed. Continuing anyway"
  else
    echo "* neovim repository not found in $HOME/.local/neovim, cloning..."
    git clone git@github.com:neovim/neovim.git
    cd neovim

    echo "* Installing build prerequisites"
    install_build_prerequisites

    echo "* Installing runtime prerequisites"
    install_runtime_prerequisites
  fi

  echo "* Building neovim"
  build_neovim
  nvim -v
  popd >/dev/null

  echo "* Stowing config files"
  ./stow.sh
  echo "* Done"
}

function install_runtime_prerequisites {
  # Install python3 provider for neovim
  # See https://neovim.io/doc/user/provider.html
  python3 -m pip install --user --upgrade pynvim

  # xsel for clipboard support
  # g++ for compiling Treesitter parsers
  sudo apt install xsel g++
}

function install_build_prerequisites {
  # https://github.com/neovim/neovim/wiki/Building-Neovim#ubuntu--debian
  sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
}

function build_neovim {
  # https://github.com/neovim/neovim/wiki/Building-Neovim#quick-start
  make
  sudo make install
}

main
