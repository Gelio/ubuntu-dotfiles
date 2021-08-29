#!/usr/bin/env bash
set -euxo pipefail

# https://github.com/greshake/i3status-rust/issues/194
sudo apt install libdbus-1-dev

cd ~/.local
[[ ! -d i3status-rust ]] && git clone https://github.com/greshake/i3status-rust
cd i3status-rust
cargo install --path .
./install.sh
