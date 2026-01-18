{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    czkawka-full
    nil
    nixfmt
    niv
    nix-tree
  ];
}
