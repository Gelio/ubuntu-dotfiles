#!/usr/bin/env bash
set -euo pipefail

deb_url=https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.13/obsidian_1.4.13_amd64.deb

temp_deb_file_name=$(mktemp --tmpdir obsidian-XXX.deb)
wget "$deb_url" -O "$temp_deb_file_name"
sudo dpkg -i "$temp_deb_file_name"
rm "$temp_deb_file_name"
