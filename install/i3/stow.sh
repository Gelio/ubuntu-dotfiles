#!/usr/bin/env bash

set -euo pipefail

stow -v --restow --no-folding stowed -t "$HOME"
sudo stow -v --restow --no-folding systemd-stowed -t "/"
