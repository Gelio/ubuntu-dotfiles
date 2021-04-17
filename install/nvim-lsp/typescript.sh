#!/bin/bash

set -euo pipefail

npm install -g eslint_d typescript-language-server @fsouza/prettierd
# efm-langserver to run daemons (eslint and prettier)
go get github.com/mattn/efm-langserver
