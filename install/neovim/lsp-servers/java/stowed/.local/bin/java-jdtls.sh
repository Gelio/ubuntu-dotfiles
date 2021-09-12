#!/usr/bin/env bash

# See https://github.com/mfussenegger/nvim-jdtls#language-server-installation
# NOTE: assumes it's on Linux

jdt_dir_path="$HOME/.local/jdt-language-server"
# Dynamically gets the file name that matches this pattern
JAR=$(echo $jdt_dir_path/plugins/org.eclipse.equinox.launcher_*.jar)
java_bin=/usr/lib/jvm/java-11-openjdk-amd64/bin/java

GRADLE_HOME=$HOME/gradle $java_bin \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -jar "$JAR" \
  -configuration "$jdt_dir_path/config_linux" \
  -data "${1:-$HOME/workspace}" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED
