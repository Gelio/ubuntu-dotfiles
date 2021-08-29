#!/usr/bin/env bash

set -eou pipefail

cd ~/.local
[[ ! -d i3-volume ]] && git clone git@github.com:hastinbe/i3-volume.git
ln -s "$PWD/volume" ~/.local/bin/volume
