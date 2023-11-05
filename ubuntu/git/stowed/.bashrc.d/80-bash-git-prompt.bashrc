#!/usr/bin/env bash

# https://github.com/magicmonty/bash-git-prompt#all-configs-for-bashrc

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
  export GIT_PROMPT_ONLY_IN_REPO=0
  source "$HOME/.bash-git-prompt/gitprompt.sh"
fi
