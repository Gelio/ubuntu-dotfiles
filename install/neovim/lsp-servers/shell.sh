#!/usr/bin/env bash

set -euo pipefail

sudo apt install shellcheck
go get -u mvdan.cc/sh/v3/cmd/shfmt
