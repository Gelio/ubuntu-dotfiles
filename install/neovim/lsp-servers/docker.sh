#!/usr/bin/env bash

set -euo pipefail

wget https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -O ~/.local/bin/hadolint
chmod u+x ~/.local/bin/hadolint
