#!/bin/bash

sudo add-apt-repository ppa:slgobinath/safeeyes
sudo apt update
sudo apt install safeeyes

if [ "$?" -eq "0" ]; then
	echo "Installation successful. Run the SafeEyes application manually now"
fi
