#!/bin/bash

# https://github.com/ajeetdsouza/zoxide
cargo install zoxide
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
echo "Source ~/.bashrc for zoxide to be initialized"
