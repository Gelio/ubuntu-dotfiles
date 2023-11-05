#!/usr/bin/env bash
set -euo pipefail

./install-zsh.sh
./stow.sh
./brew-install.sh
