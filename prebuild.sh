#!/usr/bin/env bash
set -e

REPO_ROOT="$(dirname "$(readlink -f "$0")")"
cd "$REPO_ROOT"
printf "%s" "$REPO_ROOT" > .root
git add -N .
nix flake update --offline $(for d in nixos/*/flake.nix; do basename $(dirname "$d"); done)
