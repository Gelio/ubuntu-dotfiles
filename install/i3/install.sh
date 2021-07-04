#!/usr/bin/env bash
set -euxo pipefail

I3_ADDITIONAL_PACKAGES=lxappearance picom hsetroot rofi xsettingsd \
	fonts-font-awesome numlockx xfce4-power-manager
POLYBAR_PACKAGES=polybar mpd
SCREENSAVER_PACKAGES=xscreensaver xscreensaver-gl-extra
ROFIMOJI_PACKAGES=python3 python3-pip xdotool

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install i3-gaps $I3_ADDITIONAL_PACKAGES \
	$ROFIMOJI_PACKAGES \
	$POLYBAR_PACKAGES \
	$SCREENSAVER_PACKAGES

echo "Run lxappearance and set the theme (perhaps Adwaita-dark)"
echo "Run xfce4-power-manager-settings and set correct power-level behavior"

# https://github.com/Mange/rofi-emoji
echo "Installing rofimoji"
pip install --user rofimoji

# xscreensaver
echo "Configure screensaver using 'xscreensaver-demo'"
echo "1. Create a single directory, and put the screensaver image there."
echo "2. Select the GLSlideshow screensaver, and point it to that directory."
echo "3. In the Advanced settings for GLSlideshow, do: 'glslideshow -root -fade 0 -zoom 100'"

# Wallpaper
echo "Configure wallpaper using feh:"
echo "feh --bg-center [path to wallpaper]"

stow stowed -t $HOME

# https://github.com/polybar/polybar/wiki/Configuration
echo "Installing polybar"
mkdir -p ~/.local/share/polybar
ln -s $PWD/launch_polybar.sh ~/.local/share/polybar/launch_polybar.sh
ln -s $PWD/polybar_config ~/.config/polybar/config
