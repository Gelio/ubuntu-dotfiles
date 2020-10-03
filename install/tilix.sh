#!/bin/bash

# https://www.ubuntuupdates.org/package/core/focal/universe/base/tilix

wget http://security.ubuntu.com/ubuntu/pool/universe/t/tilix/tilix_1.9.3-4build3_amd64.deb
sudo dpkg -i tilix_1.9.3-4build3_amd64.deb
rm tilix_1.9.3-4build3_amd64.deb
