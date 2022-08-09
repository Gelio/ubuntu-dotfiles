#!/usr/bin/env bash
set -euo pipefail

# Adds a new xrandr mode with refresh frequency set to 60Hz.
# Helps use less battery.
# Source:
# https://askubuntu.com/questions/59621/how-to-change-the-monitors-refresh-rate/59626#59626

width=1920
height=1080
frequency_hz=60

modeline=$(cvt $width $height $frequency_hz | tail -n 1 | cut -d " " -f 2-)
mode=$(echo "$modeline" | cut -d " " -f 1)

output=$(xrandr | grep eDP | cut -d " " -f 1)

# NOTE: it is intentional to pass the modeline as multiple arguments
# shellcheck disable=2086
xrandr --newmode $modeline
xrandr --addmode "$output" "$mode"
xrandr --output "$output" --mode "$mode"
