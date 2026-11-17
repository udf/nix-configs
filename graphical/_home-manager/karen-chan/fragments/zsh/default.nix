{ lib, pkgs, ... }:
{
  programs.zsh.initContent = lib.mkAfter (builtins.readFile ./zshrc);
  programs.zsh.profileExtra = lib.mkAfter (builtins.readFile ./zprofile);
}
