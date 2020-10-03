#!/bin/bash

wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
unzip exa-linux-x86_64-0.9.0.zip
rm exa-linux-x86_64-0.9.0.zip

echo "alias ls='$(pwd)/exa-linux-x86_64'" >> ~/.bash_aliases
source ~/.bash_aliases
