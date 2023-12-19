#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open new application
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🛩
# @raycast.packageName yabaictl
# @raycast.argument1 { "type": "text", "placeholder": "application name" }

open -n -a "$1"
