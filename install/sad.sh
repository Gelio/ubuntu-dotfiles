#!/usr/bin/env bash

set -euo pipefail

cargo install --locked --all-features \
  --git https://github.com/ms-jpq/sad --branch senpai
