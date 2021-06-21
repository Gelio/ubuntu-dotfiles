#!/bin/bash

wget https://github.com/meetfranz/franz/releases/download/v5.7.0/franz_5.7.0_amd64.deb -O franz.deb
sudo dpkg -i franz.deb
rm franz.deb
