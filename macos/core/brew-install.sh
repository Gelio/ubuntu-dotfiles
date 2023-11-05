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
casks_no_quarantine=(
  stretchly
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
brew install --cask --no-quarantine ${casks_no_quarantine[@]}

cargo install cargo-update
pipx ensurepath
