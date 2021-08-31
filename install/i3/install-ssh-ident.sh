#!/usr/bin/env bash

set -euo pipefail

cd ~/.local
[ ! -d ssh-ident ] && git clone git@github.com:ccontavalli/ssh-ident.git
cd ssh-ident
ln -s "$PWD/ssh-ident" ~/.local/bin/ssh
./stow.sh
