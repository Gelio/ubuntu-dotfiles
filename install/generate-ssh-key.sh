#!/bin/bash

ssh-keygen -t rsa -b 4096 -C "voreny.gelio@gmail.com"
cat ~/.ssh/id_rsa.pub
