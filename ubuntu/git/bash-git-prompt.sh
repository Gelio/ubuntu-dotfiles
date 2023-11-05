#!/usr/bin/env bash

set -euo pipefail

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
./stow.sh
