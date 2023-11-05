#!/usr/bin/env bash
set -euo pipefail

casks=(
  bitwarden
  firefox
  karabiner-elements
  rambox
  obsidian
  kitty
)

formulae=(
  go
  rust
  nvm
  koekeishiya/formulae/yabai
  stow
  koekeishiya/formulae/skhd
  tmux
  findutils
  wget
  pipx
)

echo "# Installing formulae"
echo "${formulae[@]}"
brew install ${formulae[@]}

echo "# Installing casks"
echo "${casks[@]}"
brew install --cask ${casks[@]}

cargo install cargo-update
pipx ensurepath
