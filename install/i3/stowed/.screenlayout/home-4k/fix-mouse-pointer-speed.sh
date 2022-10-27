#!/usr/bin/env bash
set -euo pipefail

# Enable pointer acceleration since the default mouse speed is hard to use
xinput set-prop "pointer:Logitech MX Master 3" 327 0.7
