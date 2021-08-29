#!/usr/bin/env bash

set -euo pipefail

# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-update
# https://github.com/sfackler/rust-openssl/issues/763#issuecomment-339269157
sudo apt install libssl-dev
