#!/usr/bin/env bash
set -e

[ -z "$1" ] && echo "No host supplied" && exit 1

git add -N .

for host in "$@"; do
  echo "Syncing to $host..."
  rsync -rah --info=progress2 --exclude=flake.lock --delete ./ $host:~/nixos/

  echo "Updating lockfiles on $host..."
  rsync -au --info=progress2 \
    --include='*/' --include='flake.lock' --exclude='*' \
    ./ "$host:~/nixos/"

  echo "Pulling lockfiles from $host..."
  rsync -au --info=progress2 \
    --include='*/' --include='flake.lock' --exclude='*' \
    "$host:~/nixos/" ./
done
