#!/usr/bin/env bash
set -eou pipefail

karabiner_config_path=~/.config/karabiner/karabiner.json

if [ ! -f "$karabiner_config_path" ]; then
  echo "Karabiner config not found at $karabiner_config_path"
  exit 1
fi

stowed_karabiner_config_path=./stowed/.config/karabiner/karabiner.json

# NOTE: `&& true` is used to prevent the script from exiting due to "set -e"
diff "$karabiner_config_path" "$stowed_karabiner_config_path" >/dev/null && true
error_code=$?

if [ $error_code -eq 0 ]; then
  echo "Karabiner config is already up to date"
  exit 0
fi

cp "$karabiner_config_path" "$stowed_karabiner_config_path"
echo "Karabiner config copied to $stowed_karabiner_config_path"
