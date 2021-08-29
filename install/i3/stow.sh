#!/usr/bin/env bash

set -euo pipefail

stow -v stowed -t "$HOME"
sudo stow -v systemd-stowed -t "/usr/lib/systemd/" -v
