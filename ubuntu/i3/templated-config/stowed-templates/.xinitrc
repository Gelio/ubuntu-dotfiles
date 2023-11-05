#!/usr/bin/env bash

xrdb -merge ~/.Xresources
export GDK_SCALE={{ (ds "config").dpi }}
export GDK_DPI_SCALE={{ math.Div 1 (ds "config").dpi }}

laptop_output=$(xrandr | grep eDP | cut -d' ' -f1)
# NOTE: cannot use double brackets in ifs
if [ -n "$laptop_output" ]; then
  xrandr --output "$laptop_output" --auto --primary
else
  echo "Cannot find laptop output in xrandr."
  echo "Most likely the laptop screen will not turn on automatically."
  echo "In another tty, run: sleep 5 && xrandr [...]"
  echo "to change xrandr settings. Then, before 5 seconds pass, switch to the tty that has the X session."
fi

STARTUP=i3
. /etc/X11/Xsession
