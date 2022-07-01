#!/usr/bin/env bash
set -euo pipefail

cd ~/ubuntu-dotfiles/install/i3/templated-config
./generate-config.sh configs/regular-dpi.json

exec startx
