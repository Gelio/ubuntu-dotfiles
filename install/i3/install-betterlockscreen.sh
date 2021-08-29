#!/usr/bin/env bash

set -euo pipefail

sudo apt install imagemagick

VERSION="v4.0.3"
wget https://git.io/JZyxV -O - -q | sudo bash -s system $VERSION true

./stow.sh
# https://github.com/betterlockscreen/betterlockscreen#systemd-service-lockscreen-after-sleepsuspend
sudo systemctl enable "betterlockscreen@$USER"

cargo install xidlehook --bins
cargo install --git https://github.com/rschmukler/caffeinate

echo "Configure betterlockscreen"
echo "https://github.com/betterlockscreen/betterlockscreen#configuration"
