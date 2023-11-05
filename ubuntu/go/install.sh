#!/usr/bin/env bash

set -euo pipefail

# Get the name from https://golang.org/doc/install
file=go1.21.1.linux-amd64.tar.gz

go_installed=$(command -v go || true)
if [ -n "$go_installed" ]; then
  echo "go is already installed. Upgrading..."
  sudo rm -rf /usr/local/go
else
  echo "go is not installed. Installing..."
fi

wget https://golang.org/dl/$file
sudo tar -C /usr/local -xzf $file
rm $file

stow -v --no-folding -t "$HOME" stowed

/usr/local/go/bin/go version

echo "go should be installed. Run 'source ~/.bashrc' to start using it"
