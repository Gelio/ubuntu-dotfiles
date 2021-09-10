#!/usr/bin/env bash
# set -euo pipefail

if ! command -v "mvn" >/dev/null; then
  echo "Installing maven"
  sudo apt install maven
fi

installed_java_versions=$(update-java-alternatives --list)

if [[ ! $installed_java_versions =~ "1.13" ]]; then
  echo "Installing openjdk-13"
  sudo apt install openjdk-13-jdk
fi

cd ~/.local
if [ -d java-language-server ]; then
  echo "java-language-server already cloned. Pulling new changes"
  cd java-language-server
  git pull
else
  echo "Cloning java-language-server"
  git clone git@github.com:georgewfraser/java-language-server.git
  cd java-language-server
fi

# Run similiar instructions to
# https://github.com/georgewfraser/java-language-server#vim-with-vim-lsc
# but use nvim-lspconfig instead of vim-lsc

echo "This script assumes you're on Linux. If you are not, see the source code and run instructions yourself"
read -p "Continue? [y/N] " -n 1 -r
echo # newline

if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/link_linux.sh
  mvn package -DskipTests
fi
