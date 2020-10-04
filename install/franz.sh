#!/bin/bash

wget https://github.com/meetfranz/franz/releases/download/v5.5.0/franz_5.5.0_amd64.deb
sudo dpkg -i franz_5.5.0_amd64.deb
rm franz_5.5.0_amd64.deb
