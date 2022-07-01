#!/usr/bin/env bash
set -euxo pipefail

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

# It is easier to disable the internal screen than make it usable
xrandr --output eDP-1-0 --off
xrandr --output HDMI-0 --auto --scale "${scale}x${scale}" --panning "${scaled_width}x${scaled_height}+0+0"
xrandr --output DP-0 --auto --scale "${scale}x${scale}" --panning "${scaled_width}x${scaled_height}+${scaled_width}+0"
~/.fehbg

# Enable pointer acceleration since the default mouse speed is hard to use
xinput set-prop "pointer:Logitech MX Master 3" 327 0.7
