#!/bin/bash

set -euo pipefail

curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install > /tmp/install-navi.sh
chmod u+x /tmp/install-navi.sh
sudo /tmp/install-navi.sh
rm /tmp/install-navi.sh

