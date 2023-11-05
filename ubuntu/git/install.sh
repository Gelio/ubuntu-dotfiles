#!/usr/bin/env bash
set -euo pipefail

# Source: https://gist.github.com/YuMS/6d7639480b17523f6f01490f285da509
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git -y

echo "Now run the install script from the universal directory"
