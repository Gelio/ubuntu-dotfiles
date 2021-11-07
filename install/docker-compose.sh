#!/bin/bash

# https://docs.docker.com/compose/install/

version=1.27.4

sudo curl -L "https://github.com/docker/compose/releases/download/$version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose -h

# Add bash completions
# https://docs.docker.com/compose/completion/#bash
sudo curl -L https://raw.githubusercontent.com/docker/compose/$version/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
