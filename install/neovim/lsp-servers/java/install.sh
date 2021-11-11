#!/usr/bin/env bash
set -euo pipefail

if ! command -v "mvn" >/dev/null; then
  echo "maven not found. Please install it first"
  exit 1
fi

dir_name=jdt-language-server
filename=$dir_name.tar.gz
jdt_dir_path="$HOME/.local/$dir_name"

if [ -d "$jdt_dir_path" ]; then
  echo "jdt language server already installed. Removing"
  rm -rf "${jdt_dir_path:?}/*"
else
  mkdir -p "$jdt_dir_path"
fi

pushd "$jdt_dir_path" >/dev/null
# https://download.eclipse.org/jdtls/milestones/
wget https://download.eclipse.org/jdtls/milestones/1.3.0/jdt-language-server-1.3.0-202108171748.tar.gz -O $filename
tar -xzvf $filename
rm $filename

popd >/dev/null

pushd "$HOME/.local" >/dev/null
# https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
java_debug_dir_name="java-debug"
if [[ -d "$java_debug_dir_name" ]]; then
  cd "$java_debug_dir_name"
  git pull
else
  git clone git@github.com:microsoft/$java_debug_dir_name.git
  cd "$java_debug_dir_name"
fi
./mvnw clean install
popd >/dev/null

echo "Stowing dotfiles"
stow -Rv --no-folding -t "$HOME" stowed
