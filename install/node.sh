#!/bin/bash
set -e

nvm install --lts
nvm use --lts
npm completion >> ~/.bashrc
