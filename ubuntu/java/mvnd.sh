#!/usr/bin/env bash
set -euo pipefail

mvnd_version=0.6.0
file_name="mvnd-$mvnd_version-linux-amd64.zip"
dir_name=$(basename "$file_name" .zip)

# https://github.com/mvndaemon/mvnd#install-manually

pushd ~/.local >/dev/null
wget "https://github.com/mvndaemon/mvnd/releases/download/0.6.0/$file_name"
unzip "$file_name"
rm "$file_name"

pushd "$dir_name" >/dev/null
stow -t "$HOME/.local/bin" bin

JAVA_HOME=${JAVA_HOME-/usr/lib/jvm/java-1.11.0-openjdk-amd64}
mvnd_properties="$HOME/.m2/mvnd.properties"
echo "Using JAVA_HOME=$JAVA_HOME"
echo "If using a different one, update $mvnd_properties"
echo "java.home=$JAVA_HOME" >"$mvnd_properties"
