#!/usr/bin/env bash
set -euxo pipefail

cd ~/.local
git clone https://github.com/greshake/i3status-rust
cd i3status-rust
cargo install --path .
./install.sh
