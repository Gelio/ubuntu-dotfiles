#!/usr/bin/env bash
set -eop pipefail

# Fixes screen tearing when using nvidia

# https://askubuntu.com/questions/1170247/how-do-i-solve-screen-tearing-on-ubuntu-18-04-with-nvidia/1170313#1170313
nvidia-settings --assign CurrentMetaMode="$(xrandr | sed -nr '/(\S+) connected (primary )?([0-9]+x[0-9]+)(\+\S+).*/{ s//\1: \3 \4 { ForceCompositionPipeline = On }, /; H}; ${ g; s/\n//g; s/, $//; p }')"

# Another solution from https://www.reddit.com/r/linux_gaming/comments/aoh5be/guide_hybrid_graphics_on_linux_nvidia_optimus/
# xrandr --output eDP-1-1 --set 'PRIME Synchronization' '1'
