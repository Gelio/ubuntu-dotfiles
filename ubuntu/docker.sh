#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/

sudo apt update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io

docker -h

# Enable running docker without root privileges
# https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker $USER

# use local logging driver to prevent disk-exhaustion
# local logging driver performs log-rotation & compresses log files by
# default.
# https://docs.docker.com/config/containers/logging/configure/
# https://docs.docker.com/config/containers/logging/local/
sudo touch /etc/docker/daemon.json
echo '{"log-driver": "local", "log-opts": {"max-size": "10m"}}' \
    | sudo tee /etc/docker/daemon.json >/dev/null
