#!/usr/bin/env bash

set -euo pipefail

stow stowed -t "$HOME"
sudo stow systemd-stowed -t "/usr/lib/systemd/"
