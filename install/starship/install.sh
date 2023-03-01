#!/usr/bin/env bash
set -euo pipefail

cargo install starship --locked
stow -v --no-folding -t "$HOME" stowed
