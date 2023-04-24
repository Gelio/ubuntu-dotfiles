#!/usr/bin/env bash
set -euo pipefail

# See https://socket.dev/blog/introducing-safe-npm
npm install -g @socketsecurity/cli

stow -v --no-folding -t "$HOME" stowed
