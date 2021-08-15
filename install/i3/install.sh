#!/usr/bin/env bash
set -euxo pipefail

I3_ADDITIONAL_PACKAGES=lxappearance hsetroot rofi xsettingsd \
  fonts-font-awesome numlockx xfce4-power-manager \
  mpd playerctl xfce4-volumed autorandr
ROFIMOJI_PACKAGES=python3 python3-pip xdotool
LOCKSCREEN_PACKAGES=libxcb-screensaver0 libxcb-screensaver0-dev

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install i3-gaps $I3_ADDITIONAL_PACKAGES \
  $ROFIMOJI_PACKAGES \
  $LOCKSCREEN_PACKAGES

echo "Run lxappearance and set the theme (perhaps Adwaita-dark)"
echo "Run xfce4-power-manager-settings and set correct power-level behavior"

# https://github.com/Mange/rofi-emoji
echo "Installing rofimoji"
pip install --user rofimoji

# Wallpaper
echo "Configure wallpaper using feh:"
echo "feh --bg-center [path to wallpaper]"

# Autorandr
echo "Make sure to configure autorandr"
echo "See https://github.com/phillipberndt/autorandr"

./install-i3status-rust.sh
./install-picom.sh
./install-libinput-gestures.sh
./install-dunst.sh
./install-i3-volume.sh
./install-i3lock-color.sh
./install-betterlockscreen.sh
./install-redshift.sh

./stow.sh
