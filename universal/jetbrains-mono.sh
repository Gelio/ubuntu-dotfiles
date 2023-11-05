#!/usr/bin/env bash
set -euo pipefail

release="latest"
font_archive_url=""
archive_name="JetBrainsMono.zip"

if [[ "$release" = "latest" ]]; then
  font_archive_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
else
  font_archive_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${release}/JetBrainsMono.zip"
fi

pushd /tmp >/dev/null
wget "$font_archive_url" -O "$archive_name"
fonts_unzip_dir=./JetBrainsMono
unzip "$archive_name" -d "$fonts_unzip_dir"
rm "$archive_name"
if [[ "$(uname)" == "Darwin" ]]; then
  fonts_destination_dir=~/Library/Fonts/
else
  fonts_destination_dir=~/.local/share/fonts/
fi
mkdir -p "$fonts_destination_dir"
echo "Copying" $fonts_unzip_dir/*.ttf
cp $fonts_unzip_dir/*.ttf "$fonts_destination_dir"

echo "Font installed"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Testing installation"
  fc-list | grep "JetBrainsMono NF"
fi

# NOTE: no need to remove the archive and directory because it is in /tmp
