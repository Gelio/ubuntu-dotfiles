#!/bin/bash

curl -fsSL https://deno.land/x/install/install.sh | sh

echo 'DENO_INSTALL="$HOME/.deno"
PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.profile 

source ~/.profile

echo "Adding completions"
source ./bash-completions-dir.sh
DENO_BASH_COMPLETIONS_PATH=$BASH_COMPLETIONS_DIR/deno.bash
deno completions bash > $DENO_BASH_COMPLETIONS_PATH
echo "Completions saved to $DENO_BASH_COMPLETIONS_PATH" 
