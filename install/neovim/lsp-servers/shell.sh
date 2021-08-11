#!/usr/bin/env bash

set -euo pipefail

sudo apt install shellcheck
go get mvdan.cc/sh/v3/cmd/shfmt
