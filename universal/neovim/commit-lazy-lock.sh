#!/usr/bin/env bash
set -euo pipefail

lazy_lock_path=./config/nvim/lazy-lock.json

modified_packages=$(
  git diff --unified=0 -- "$lazy_lock_path" |
    grep "^\\+ " |
    sed -E "s/^\\+[[:space:]]+\"([^\"]+)\":.*/\1/" || true
)

if [[ -z "$modified_packages" ]]; then
  echo "Nothing to commit"
  exit 0
fi

formatted_packages=$(sed "i\\
* " <<<"$modified_packages")

commit_message="chore(nvim): update lazy-lock.json

Updated packages:
$formatted_packages"

git add "$lazy_lock_path"
git commit -m "$commit_message"
