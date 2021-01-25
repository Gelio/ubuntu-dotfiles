#!/bin/bash

sudo apt install fd-find
echo "alias fd=fdfind" >> ~/.bash_aliases

printf "Run: source ~/.bash_aliases\nto be able to run fd\n"
