#!/usr/bin/env bash
set -e

cd "$(dirname "$(readlink -f "$0")")"
git add -N .
nix flake update --offline $(for d in nixos/*/flake.nix; do basename $(dirname "$d"); done)
