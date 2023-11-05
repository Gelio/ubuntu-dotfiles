#!/usr/bin/env bash

set -euo pipefail

# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Source to be able to run cargo in this script
source "$HOME/.cargo/env"
cargo install cargo-update
# https://github.com/sfackler/rust-openssl/issues/763#issuecomment-339269157
sudo apt install libssl-dev
