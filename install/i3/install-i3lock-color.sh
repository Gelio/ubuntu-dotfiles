#!/usr/bin/env bash

set -euo pipefail

# https://github.com/Raymo111/i3lock-color
# Remove the default i3lock as i3lock-color uses the same binary name
# Otherwise, e.g. man pages will not be installed
sudo apt remove i3lock

# https://github.com/Raymo111/i3lock-color#ubuntu-182004-lts
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxcb-xtest0-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

cd ~/.local
# https://github.com/Raymo111/i3lock-color#building-i3lock-color
[[ ! -d i3lock-color ]] && git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
git tag -f "git-$(git rev-parse --short HEAD)"
./install-i3lock-color.sh
