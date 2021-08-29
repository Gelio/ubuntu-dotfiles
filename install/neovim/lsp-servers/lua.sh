#!/usr/bin/env bash

set -euo pipefail

# https://www.chrisatmachine.com/Neovim/28-neovim-lua-development/

sudo apt install ninja-build

cd ~/.config/nvim
[[ ! -d lua-language-server ]] && git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive

# https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild

# Formatter
cargo install stylua
# Linter
cargo install selene
