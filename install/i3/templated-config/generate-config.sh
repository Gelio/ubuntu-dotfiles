#!/usr/bin/env bash
set -euo pipefail

# Allows running the script from any directory
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

config=${1:-""}

function usage() {
  echo "Usage: $0 [config]"

  echo "[config] should be a path to a file inside the configs directory"
}

if [[ -z "$config" ]]; then
  usage
  exit 1
fi

if [[ ! -f "$config" ]]; then
  echo "$config does not exist"
  usage
  exit 2
fi

templates_dir=./stowed-templates/
output_dir=stowed-generated

rm "$output_dir" -rf
ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH=go1.20 gomplate \
  "--input-dir=${script_dir}/${templates_dir}" \
  "--output-dir=${script_dir}/${output_dir}/" \
  --datasource "config=$config"

pushd "$script_dir" >/dev/null
stow -v --no-folding --restow -t "$HOME" "$output_dir"
