#!/bin/bash

set -euo pipefail

npm install -g eslint_d typescript-language-server @fsouza/prettierd vscode-json-languageserver
# efm-langserver to run daemons (eslint and prettier)
go get -u github.com/mattn/efm-langserver
