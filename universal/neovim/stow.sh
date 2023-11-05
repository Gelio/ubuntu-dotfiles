#!/usr/bin/env bash
set -euo pipefail

stow -v --no-folding -R -t "$HOME" stowed

# Stow .config/nvim without folding.
# This way all new files created by nvim in .config/nvim (like spell files) are
# added into this repository.
stow -v -t "$HOME/.config/" config
