#!/usr/bin/env bash
set -euo pipefail

# Allows running the script from any directory
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
pushd "$script_dir" >/dev/null

clean_before_build=false
if [[ "${1-}" == "--clean" ]] || [[ "${1-}" == "-c" ]]; then
  clean_before_build=true
fi

function main {
  pushd ~/.local >/dev/null
  if [[ -d neovim ]]; then
    cd neovim
    echo "* neovim repository found at $PWD, pulling latest changes..."
    # Pulling fails most likely when a hash is checked out, not a branch.
    # This is normal when there are breaking changes on master and a previous
    # commit is used to build neovim.
    git pull || echo "Pulling latest changes failed. Continuing anyway"

    # Sometimes there are ninja build permissions errors because some files
    # are owned by root instead of the current user.
    # [3/3] cd /home/voreny/.local/neovim/.deps && /usr/bin/cmake -E touch .third-party
    # ninja  -C build
    # ninja: Entering directory `build'
    # ninja: error: opening build log: Permission denied
    # make: *** [Makefile:92: nvim] Error 1
    sudo chown -R "$USER" .
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
  # https://github.com/neovim/neovim/wiki/Building-Neovim#building
  if [[ "$clean_before_build" == true ]]; then
    make distclean
  fi
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
}

main
