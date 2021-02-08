#!/bin/bash

# https://github.com/Eitol/screen_focus_changer

OUT_DIR=~/.local/share/screen-focus-changer
mkdir -p $OUT_DIR

sudo apt install wget xdotool x11-xserver-utils python3
wget -qO $OUT_DIR/focus_changer.py https://raw.githubusercontent.com/Eitol/screen_focus_changer/master/focus_changer.py

echo "Script downloaded to $OUT_DIR/focus_changer.py"
