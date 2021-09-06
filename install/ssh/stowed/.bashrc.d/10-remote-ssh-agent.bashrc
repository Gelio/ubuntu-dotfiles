#!/usr/bin/env bash

# Predictable SSH authentication socket location
# https://unix.stackexchange.com/a/76256/490740
sock="/tmp/ssh-agent-$USER-screen"
if test $SSH_CONNECTION && test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $sock ]; then
  rm -f $sock
  ln -sf $SSH_AUTH_SOCK $sock
  export SSH_AUTH_SOCK=$sock
fi
