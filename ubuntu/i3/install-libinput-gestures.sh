#!/usr/bin/env bash
set -eou pipefail

# https://github.com/bulletmark/libinput-gestures#installation

sudo gpasswd -a "$USER" input
echo "You may need to reboot for the tool to work"
sudo apt install wmctrl xdotool libinput-tools

cd ~/.local
[[ ! -d libinput-gestures ]] && git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install

libinput-gestures-setup autostart start
echo "Make sure you use stow to install config into ~/.config"
