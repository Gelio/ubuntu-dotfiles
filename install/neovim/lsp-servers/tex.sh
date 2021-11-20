#!/usr/bin/env bash
set -euo pipefail

cargo install --git https://github.com/latex-lsp/texlab.git --locked
pip3 install --user https://github.com/efoerster/evince-synctex/archive/master.zip
sudo apt install chktex
