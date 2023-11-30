#!/usr/bin/env bash
set -euo pipefail

casks=(
  bitwarden
  firefox
  karabiner-elements
  rambox
  obsidian
  kitty
  aldente
  ubersicht
  raycast
  kap
)
casks_no_quarantine=(
  stretchly
)

formulae=(
  go
  koekeishiya/formulae/yabai
  stow
  koekeishiya/formulae/skhd
  tmux
  findutils
  wget
  pipx
  gnupg
  jq
  highlight
)

echo "# Installing formulae"
echo "${formulae[@]}"
brew install ${formulae[@]}

echo "# Installing casks"
echo "${casks[@]}"
brew install --cask ${casks[@]}
brew install --cask --no-quarantine ${casks_no_quarantine[@]}

if ! type rustup >/dev/null 2>&1; then
  # Install rustup
  echo "Installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

cargo install cargo-update
cargo install git-stack
cargo install git-branch-stash-cli
cargo install --locked git-branchless
go install github.com/Gelio/go-global-update@latest
pipx ensurepath
skhd --start-service

# https://github.com/Jean-Tinland/simple-bar#installation
simple_bar_dir="$HOME/Library/Application Support/Übersicht/widgets/simple-bar"
if [[ -d "$simple_bar_dir" ]]; then
  cd "$simple_bar_dir"
  echo "Updating simple-bar"
  git pull
  cd - >/dev/null
else
  echo "Pulling simple-bar"
  git clone https://github.com/Jean-Tinland/simple-bar "$simple_bar_dir"
fi

yabai_symlink=/usr/local/bin/yabai
if [[ ! -f "$yabai_symlink" ]]; then
  sudo ln -s /opt/homebrew/bin/yabai $yabai_symlink
fi
