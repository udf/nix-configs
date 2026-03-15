{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    czkawka-full
    nixd
    nixfmt
    niv
    nix-tree
    git-crypt
  ];
}
