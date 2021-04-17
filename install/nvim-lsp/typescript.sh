#!/bin/bash

set -euo pipefail

npm install -g eslint_d typescript-language-server
# efm-langserver used to run eslint as a daemon
go get github.com/mattn/efm-langserver
