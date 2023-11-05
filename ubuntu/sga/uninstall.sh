#!/usr/bin/env bash

set -euo pipefail

directory_name="sga_linux_amd64"

pushd ~/.local >/dev/null
sudo stow -Dv -t /usr/local/bin $directory_name
rm -r $directory_name
popd >/dev/null

stow -Dv -t "$HOME" stowed
