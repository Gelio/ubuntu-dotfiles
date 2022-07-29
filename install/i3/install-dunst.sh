#!/usr/bin/env bash

set -euo pipefail

# Remove dunst that is installed by default with i3
sudo apt remove dunst

# https://github.com/dunst-project/dunst/wiki/Dependencies#ubuntu
sudo apt install libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev \
  libpango1.0-dev libgtk-3-dev libxdg-basedir-dev libnotify-dev

force_install=0
if [[ "$1" == "--force" || "$1" == "-f" ]]; then
  force_install=1
fi

cd ~/.local
# https://github.com/dunst-project/dunst#building
if [[ -d dunst ]]; then
  cd dunst
  new_commits=$(git log '..@{u}' --oneline | wc -l)
  echo "There are $new_commits new commits"

  if [[ "$new_commits" -eq 0 ]]; then
    echo "Update is not necessary"

    if [[ "$force_install" -eq 1 ]]; then
      echo "Forcing the install because the $1 flag was used"
    else
      echo "Skipping the installation and existing"
      exit 0
    fi
  fi

  echo "Pulling in latest changes..."
  git pull
else
  git clone https://github.com/dunst-project/dunst.git
  cd dunst
fi

make
sudo make install
