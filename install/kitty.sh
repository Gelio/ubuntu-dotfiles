#!/usr/bin/env bash
set -euo pipefail

UPGRADE_ONLY=$(which kitty || true)

if  [ -n "$UPGRADE_ONLY" ]; then
  echo "Upgrading kitty"
else
  echo "Installing kitty"
fi

# https://sw.kovidgoyal.net/kitty/binary.html#kitty-binary-install
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

if [ -n "$UPGRADE_ONLY" ]; then
  kitty -v
  echo "kitty upgraded, exiting"
  exit 0
fi

CONFIGS_DIR="$(dirname $PWD)/configs"
ln -s "$CONFIGS_DIR/kitty.conf" ~/.config/kitty/
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop

echo "kitty installed"

HAS_FIRACODE=$(fc-list | grep "FiraCode Nerd Font" || true)

if [ -z "$HAS_FIRACODE" ]; then
  echo "Make sure to install the FiraCode Nerd Font"
  echo "https://www.nerdfonts.com/"
fi