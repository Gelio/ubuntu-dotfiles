#!/usr/bin/env bash
set -euo pipefail

UPGRADE_ONLY=$(which kitty || true)

if [ -n "$UPGRADE_ONLY" ]; then
  echo "Upgrading kitty"
else
  echo "Installing kitty"
fi

# https://sw.kovidgoyal.net/kitty/binary.html#kitty-binary-install
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

if [ -n "$UPGRADE_ONLY" ]; then
  kitty -v
  echo "kitty upgraded, exiting"
  exit 0
fi

# Make sure SSH works
# https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
echo "alias kittyssh='kitty +kitten ssh'" >>~/.bash_aliases

./stow.sh

cd ~/.local/kitty.app
stow -v .

echo "kitty installed"

font_installed=$(fc-list | grep "JetBrainsMono NF" || true)

if [ -z "$font_installed" ]; then
  echo "Make sure to install the JetBrains Mono Nerd Font"
  echo "https://www.nerdfonts.com/"
fi
