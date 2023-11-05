#!/usr/bin/env bash
set -euxo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Enable both 4k monitors horizontally.
# The logic goes like this:
# 1. Use 4k resolution on each monitor. Set DPI to 2x the normal DPI.
# 2. Use xrandr to scale the output back down.
# This means we need to come up with a scale that satisfies:
# 1440p * 2 = 2160p * scale

width=3840
height=2160
scale="1.333333333"

# +0.5 is for rounding. /1 will cut off the decimal places, so we need to add
# 0.5 to get bc to round the number instead.
scaled_width=$(bc <<<"($scale * $width + 0.5) / 1")
scaled_height=$(bc <<<"($scale * $height + 0.5) / 1")

# I could not get the internal screen to work when using --scale.
# There were always xrandr errors related to RRSetPanning
# NOTE: sometimes the laptop output is eDP-1-0 and sometimes eDP-1-1
laptop_output=$(xrandr | grep eDP | cut -d' ' -f1)
xrandr --output "$laptop_output" --off

right_monitor_output=$(xrandr | grep 'DP-[0-9] connected' | cut -d' ' -f1)

xrandr --output HDMI-0 --auto --primary --scale "${scale}x${scale}" --panning "${scaled_width}x${scaled_height}+0+0"
xrandr --output "$right_monitor_output" --auto --scale "${scale}x${scale}" --panning "${scaled_width}x${scaled_height}+${scaled_width}+0"
~/.fehbg

pushd "$script_dir" >/dev/null
./fix-mouse-pointer-speed.sh
