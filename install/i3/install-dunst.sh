#!/usr/bin/env bash

set -euo pipefail

# https://github.com/dunst-project/dunst/wiki/Dependencies#ubuntu
sudo apt install libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev \
  libpango1.0-dev libgtk-3-dev libxdg-basedir-dev libnotify-dev

cd ~/.local
git clone https://github.com/dunst-project/dunst.git
cd dunst
make
sudo make install