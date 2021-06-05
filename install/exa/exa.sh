#!/bin/bash

set -euxo pipefail

cargo install exa

if [ -z "${UPGRADE_ONLY:-}" ]; then
    echo "alias ls='exa'" >> ~/.bash_aliases
    echo "alias l='ls -al'" >> ~/.bash_aliases
    echo "alias la='ls -a'" >> ~/.bash_aliases
    source ~/.bash_aliases
fi
