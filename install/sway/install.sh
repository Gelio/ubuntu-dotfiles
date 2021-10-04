#!/usr/bin/env bash
set -euo pipefail

function main {
  pushd ~/.local >/dev/null

  install_dependencies
  install_using_wayland_build_tools
  # install_sway
}

function clone_or_pull {
  local git_clone_url="$1"
  local dir_name
  dir_name=$(basename "$git_clone_url")

  if [[ -d "$dir_name" ]]; then
    pushd "$dir_name" >/dev/null
    git pull
    popd >/dev/null
  else
    git clone "$git_clone_url"
  fi
}

function install_using_wayland_build_tools {
  # https://github.com/wayland-project/wayland-build-tools
  clone_or_pull git://anongit.freedesktop.org/wayland/wayland-build-tools
  pushd wayland-build-tools >/dev/null

  mkdir ~/Wayland
  mkdir -p ~/.config/wayland-build-tools
  cp wl_defines.sh ~/.config/wayland-build-tools/

  ./wl_install_deps
  ./wl_clone
  ./wl_build

  popd >/dev/null
}

function install_dependencies {
  pip3 install --user meson
  # Also install as root so `sudo ninja` works
  # https://github.com/mesonbuild/meson/issues/7258
  sudo pip3 install meson
  sudo apt install libjson-c-dev libinput-dev
  # Maybe cmake too?
}

function install_sway {
  # https://github.com/swaywm/sway/wiki/Development-Setup#compiling-as-a-subproject
  git clone git@github.com:swaywm/sway.git
  cd sway
  git clone git@github.com:swaywm/wlroots.git subprojects/wlroots
}

main
