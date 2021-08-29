#!/usr/bin/env bash

set -euo pipefail

stow -v --no-folding stowed -t "$HOME"
sudo stow -v --no-folding systemd-stowed -t "/"
