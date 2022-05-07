#!/usr/bin/env bash
set -euxo pipefail

# https://github.com/greshake/i3status-rust/issues/194
sudo apt install libdbus-1-dev

cd ~/.local
if [[ -d i3status-rust ]]; then
  cd i3status-rust
  git pull
else
  git clone https://github.com/greshake/i3status-rust
  cd i3status-rust
fi

cargo install --path .
./install.sh
