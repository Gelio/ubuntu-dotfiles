#!/usr/bin/env bash

set -euo pipefail

# Battery management
# https://linrunner.de/tlp/introduction.html

sudo add-apt-repository ppa:linrunner/tlp
sudo apt update
sudo apt install tlp tlp-rdw
sudo tlp start
