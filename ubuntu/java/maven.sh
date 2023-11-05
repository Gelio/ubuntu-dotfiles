#!/usr/bin/env bash

set -euo pipefail

# Manual install to get the latest version.
# Apt repositories had an outdated version when writing this script.
version=3.8.2
directory_name="apache-maven-$version"
filename="$directory_name-bin.tar.gz"

pushd ~/.local >/dev/null
wget "https://dlcdn.apache.org/maven/maven-3/$version/binaries/$filename"

if [ -d apache-maven ]; then
  echo "Removing existing version of maven"
  rm -rf apache-maven
fi

echo "Untarring $filename"
tar -xzvf $filename
rm $filename
mv $directory_name apache-maven
popd >/dev/null

echo "Stowing dotfiles"
stow -Rv --no-folding -t "$HOME" stowed
