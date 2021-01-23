#/bin/bash

sudo apt install git

CONFIGS_DIR=$(dirname $PWD)/configs
printf "[include]\n\tpath = $CONFIGS_DIR/git.gitconfig" >> ~/.gitconfig

echo "git config included in ~/.gitconfig"
