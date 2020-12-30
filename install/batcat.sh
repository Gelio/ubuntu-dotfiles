#!/bin/bash
set -e

sudo apt install bat

if [ ! -f /usr/bin/bat ] && [ -f /usr/bin/batcat ]; then
	sudo ln -s batcat /usr/bin/bat
	echo "Added a symlink from /usr/bin/bat to batcat"
fi
