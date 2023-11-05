#!/usr/bin/env bash

set -euo pipefail

if [ ! -f "$HOME/.config/safeeyes/safeeyes.json" ]; then
  echo "Safeeyes was not run and the config is not created. Running it manually"
  safeeyes
fi

rm ~/.config/safeeyes/safeeyes.json
./stow.sh
