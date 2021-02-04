#!/bin/bash
set -e

nvm install --lts
nvm use --lts

echo "Adding completions"
source ./bash-completions-dir.sh
NPM_BASH_COMPLETIONS_PATH=$BASH_COMPLETIONS_DIR/npm.bash
npm completion > $NPM_BASH_COMPLETIONS_PATH
echo "Completions saved to $NPM_BASH_COMPLETIONS_PATH" 
