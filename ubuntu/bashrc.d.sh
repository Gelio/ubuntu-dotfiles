#!/usr/bin/env bash

set -euo pipefail

# Inspired by https://waxzce.medium.com/use-bashrc-d-directory-instead-of-bloated-bashrc-50204d5389ff

mkdir -p ~/.bashrc.d

execute_all_bashrc_d_files=$(
  cat <<EOF

for file in ~/.bashrc.d/*.bashrc; do
  source "\$file"
done
EOF
)

first_line=$(echo "$execute_all_bashrc_d_files" | head -n 2 | tail -n 1)

if grep -Fq "$first_line" ~/.bashrc; then
  echo "Already installed"
else
  echo "$execute_all_bashrc_d_files" >>~/.bashrc
  echo "Installed correctly. source ~/.bashrc for changes to be applied"
fi
