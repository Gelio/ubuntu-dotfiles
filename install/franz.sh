#!/usr/bin/env bash
set -euo pipefail

version=5.9.2

wget "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb" -O franz.deb
sudo dpkg -i franz.deb
rm franz.deb
