#!/usr/bin/env bash
set -euxo pipefail

I3_ADDITIONAL_PACKAGES="lxappearance hsetroot rofi xsettingsd \
  fonts-font-awesome numlockx xfce4-power-manager \
  mpd playerctl xfce4-volumed feh pavucontrol arandr"
ROFIMOJI_PACKAGES="python3 python3-pip xdotool"
LOCKSCREEN_PACKAGES="libxcb-screensaver0 libxcb-screensaver0-dev"

sudo add-apt-repository ppa:regolith-linux/release
# shellcheck disable=SC2086
sudo apt install i3-wm $I3_ADDITIONAL_PACKAGES \
  $ROFIMOJI_PACKAGES \
  $LOCKSCREEN_PACKAGES

pip install autorandr

echo "Run lxappearance and set the theme (perhaps Adwaita-dark)"
echo "Run xfce4-power-manager-settings and set correct power-level behavior"

# https://github.com/fdw/rofimoji
echo "Installing rofimoji"
pip install --user rofimoji

# Wallpaper
echo "Configure wallpaper using feh:"
echo "feh --bg-center [path to wallpaper]"

# Autorandr
echo "Make sure to configure autorandr"
echo "See https://github.com/phillipberndt/autorandr"

./stow.sh

./install-i3status-rust.sh
./install-picom.sh
./install-libinput-gestures.sh
./install-dunst.sh
./install-i3lock-color.sh
./install-betterlockscreen.sh
./install-redshift.sh
./update-safeeyes-config.sh
./install-ssh-ident.sh
./install-gomplate.sh
