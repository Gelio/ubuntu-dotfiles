#!/usr/bin/env bash
set -euo pipefail

stow -v --no-folding -R -t "$HOME" stowed
