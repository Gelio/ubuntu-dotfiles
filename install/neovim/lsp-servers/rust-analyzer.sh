#!/bin/bash

set -euo pipefail

RUST_ANALYZER_URL="https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz"

wget $RUST_ANALYZER_URL -O /tmp/rust-analyzer.gz
gunzip /tmp/rust-analyzer.gz
chmod u+x /tmp/rust-analyzer
mv /tmp/rust-analyzer ~/.local/bin
