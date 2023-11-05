#!/bin/bash
set -euo pipefail

# UI for git
cargo install gitui

# https://github.com/arxanas/git-branchless
cargo install --locked git-branchless

# https://github.com/epage/git-stack
cargo install git-stack

# https://github.com/Wilfred/difftastic
cargo install difftastic

# https://github.com/jesseduffield/lazygit
go install github.com/jesseduffield/lazygit@latest
