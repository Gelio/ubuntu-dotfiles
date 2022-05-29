#!/usr/bin/env bash
set -euo pipefail

latest_release_json=$(curl https://api.github.com/repos/meetfranz/franz/releases/latest)
release_name=$(jq -r .name <<<"$latest_release_json")
echo "Latest release is $release_name"

latest_release_deb_url=$(jq -r ".assets[].browser_download_url" <<<"$latest_release_json" | grep '_amd64\.deb$')
if [[ -z "$latest_release_deb_url" ]]; then
  echo "Could not find the download URL for the latest release. Could not install"
  exit 1
fi

echo "Downloading from $latest_release_deb_url"

wget "$latest_release_deb_url" -O franz.deb
sudo dpkg -i franz.deb
rm franz.deb
