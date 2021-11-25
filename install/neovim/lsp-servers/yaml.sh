#!/usr/bin/env bash
set -euo pipefail

# yaml-language-server cannot be installed with npm due to its `engine` settings
yarn global add yaml-language-server
