#!/bin/bash

sudo apt install fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd

printf "Run: source ~/.bash_aliases\nto be able to run fd\n"
