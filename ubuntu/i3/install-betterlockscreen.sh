#!/usr/bin/env bash

set -euo pipefail

sudo apt install imagemagick

VERSION="v4.0.3"
wget https://git.io/JZyxV -O - -q | sudo bash -s system $VERSION false

./stow.sh
# NOTE: Symlinking the file does not seem to start it after reboot
# This is likely because the user's filesystem may not be mounted
# when systemd is initializing services, causing the service definition
# not to be found.
sudo cp ./betterlockscreen/betterlockscreen@.service /usr/lib/systemd/system/
# https://github.com/betterlockscreen/betterlockscreen#systemd-service-lockscreen-after-sleepsuspend
sudo systemctl enable "betterlockscreen@$USER"

cargo install xidlehook --bins
cargo install --git https://github.com/rschmukler/caffeinate

echo "Configure betterlockscreen"
echo "https://github.com/betterlockscreen/betterlockscreen#configuration"
