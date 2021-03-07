#!/bin/bash
set -e

CONFIGS_DIR=$(dirname $PWD)/configs

sudo apt install gpg
ln -s "$CONFIGS_DIR/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
echo "GPG agent config installed"
