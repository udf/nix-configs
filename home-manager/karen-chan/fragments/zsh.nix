{ lib, pkgs, ... }:
{
  programs.zsh.initContent = lib.mkAfter (builtins.readFile ./zshrc);
}
