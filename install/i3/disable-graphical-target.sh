#!/usr/bin/env bash
set -euo pipefail

# https://www.cyberciti.biz/faq/switch-boot-target-to-text-gui-in-systemd-linux/
sudo systemctl set-default multi-user.target

echo "Done. Reboot to see the changes."
