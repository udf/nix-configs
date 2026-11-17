#!/usr/bin/env bash
set -e

REPO_ROOT="$(dirname "$(readlink -f "$0")")"
cd "$REPO_ROOT"
printf "%s" "$REPO_ROOT" > .root
git add -N .
hosts=$(
  for d in graphical/*/flake.nix headless/*/flake.nix; do
    [[ "$(basename "$(dirname "$d")")" == _* ]] || basename "$(dirname "$d")"
  done
)
nix flake update --offline $hosts
