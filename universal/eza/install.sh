#!/usr/bin/env bash
set -euxo pipefail

cargo install eza

stow -t "$HOME" --no-folding -v stowed
