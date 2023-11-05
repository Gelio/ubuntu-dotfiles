#!/usr/bin/env bash

set -euo pipefail

if ! command -v node &>/dev/null; then
  echo 'Run "nvm use --lts" to install node and npm'
  exit 1
fi

echo "Adding completions"
source ./bash-completions-dir.sh
NPM_BASH_COMPLETIONS_PATH="$BASH_COMPLETIONS_DIR/npm.bash"
npm completion >$NPM_BASH_COMPLETIONS_PATH
echo "Completions saved to $NPM_BASH_COMPLETIONS_PATH"
