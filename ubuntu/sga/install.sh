#!/usr/bin/env bash

set -euo pipefail

sudo apt install jq openssh-client autossh ssh-askpass

pushd ~/.local >/dev/null
curl -L https://api.github.com/repos/StanfordSNR/guardian-agent/releases/latest |
  jq '.assets[] | select(.name | contains("linux")) | .browser_download_url' |
  xargs curl -Ls |
  tar -xzv

sudo stow -Rv -t /usr/local/bin sga_linux_amd64
popd >/dev/null

stow -Rv -t "$HOME" stowed
