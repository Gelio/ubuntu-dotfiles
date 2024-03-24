#!/usr/bin/env zsh

source <(rustup completions zsh rustup)
# Cargo completions cannot be sourced inline. They must come from a regular file.
# It is added to ~/.zfunc/_cargo in the install script.
