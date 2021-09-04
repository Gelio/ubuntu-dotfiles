#!/usr/bin/env bash

set -euo pipefail

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
