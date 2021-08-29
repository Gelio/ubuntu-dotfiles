#!/usr/bin/env bash

set -euo pipefail

sudo add-apt-repository ppa:slgobinath/safeeyes
sudo apt update
sudo apt install safeeyes
echo "Installation successful. Run the SafeEyes application manually now"
