#!/bin/bash
set -euo pipefail

# UI for git
cargo install gitui

# https://github.com/arxanas/git-branchless
cargo install --locked git-branchless

# https://github.com/epage/git-stack
cargo install git-stack
