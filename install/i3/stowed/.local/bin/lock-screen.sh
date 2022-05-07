#!/usr/bin/env bash
set -euo pipefail

fork=0
if [[ "${1:-}" == "--fork" ]]; then
  fork=1
fi

if [[ $fork -eq 1 ]]; then
  betterlockscreen -l dim &
  # NOTE: betterlockscreen takes a second or 2 to initialize,
  # so we want to wait a bit before exiting so lock-screen.sh script
  # exits when the lock screen is shown.
  sleep 2
else
  betterlockscreen -l dim
fi
