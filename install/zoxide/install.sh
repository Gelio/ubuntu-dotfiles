#!/usr/bin/env bash

set -euo pipefail

# https://github.com/ajeetdsouza/zoxide
cargo install zoxide

stow -v --no-folding -t "$HOME" stowed
echo "Source ~/.bashrc for zoxide to be initialized"
