#!/usr/bin/env bash

WINDOW_CLASS_TO_FOCUS=$1
echo "Focusing $WINDOW_CLASS_TO_FOCUS"

# https://unix.stackexchange.com/questions/399753/how-to-get-a-list-of-active-windows-when-using-wayland

gdbus call   --session   --dest org.gnome.Shell   --object-path /org/gnome/Shell   --method org.gnome.Shell.Eval "
    global
      .get_window_actors()
      .map(a=>a.meta_window)
      .filter(w => w.get_wm_class().toLowerCase().includes('$WINDOW_CLASS_TO_FOCUS'))
      .forEach(w => w.activate(0))"
