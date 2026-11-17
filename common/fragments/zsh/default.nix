{ lib, pkgs, ... }:
let
  zshrc = (import ./zshrc.nix) { inherit lib pkgs; };
in
{
  users.defaultUserShell = pkgs.zsh;

  programs.nix-index.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    setOptions = [ ];
    promptInit = "";
    enableLsColors = false;
    shellAliases = { };
    interactiveShellInit = zshrc;
    enableGlobalCompInit = false;
  };
}
