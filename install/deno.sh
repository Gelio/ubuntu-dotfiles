#!/bin/bash

curl -fsSL https://deno.land/x/install/install.sh | sh

echo 'DENO_INSTALL="$HOME/.deno"
PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.profile 
