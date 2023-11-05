#!/usr/bin/env bash
set -euo pipefail

# Enables Lenovo battery conservation mode.
# Stops charging the battery at 60%.
# Source:
# https://www.reddit.com/r/Ubuntu/comments/p2so5n/how_to_limit_battery_charging_to_60_in_ubuntu/

function print_usage {
  echo "Usage: $0 [query|on|off]"
}

if [[ "$#" -ne 1 ]]; then
  print_usage
  exit 1
fi

battery_conservation_mode_path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

case $1 in
"query")
  mode_status="$(cat $battery_conservation_mode_path)"
  user_friendly_status="OFF"
  if [[ "$mode_status" -eq 1 ]]; then
    user_friendly_status="ON"
  fi

  echo "Battery consevation mode is: $user_friendly_status"
  ;;
"on")
  echo 1 | sudo tee $battery_conservation_mode_path >/dev/null
  echo "Battery conservation mode ENABLED"
  ;;
"off")
  echo 0 | sudo tee $battery_conservation_mode_path >/dev/null
  echo "Battery conservation mode DISABLED"
  ;;
*)
  echo "Invalid parameter: $1"
  print_usage
  exit 2
  ;;
esac
