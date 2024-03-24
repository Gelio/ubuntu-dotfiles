#!/usr/bin/env bash
set -euo pipefail

# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

./stow.sh

# Source to be able to run cargo in this script
source "$HOME/.cargo/env"
cargo install cargo-update
cargo install git-stack
cargo install git-branch-stash-cli
cargo install --locked git-branchless

case "$(uname -s)" in
Darwin)
  # Cargo completions cannot be sourced inline. They must come from a regular file.
  rustup completions zsh cargo >~/.zfunc/_cargo
  ;;
Linux)
  # https://github.com/sfackler/rust-openssl/issues/763#issuecomment-339269157
  sudo apt install libssl-dev
  ;;
esac
