{
  config,
  lib,
  pkgs,
  ...
}:

let
  zshrc = (import ../../_nixos_conf/_common/fragments/zsh/zshrc.nix) { inherit lib pkgs; };
in
{
  programs.zsh = {
    enable = true;
    history = {
      append = false;
      ignoreDups = false;
      ignoreAllDups = false;
      saveNoDups = false;
      findNoDups = false;
      ignoreSpace = false;
      expireDuplicatesFirst = false;
      share = false;
      extended = false;
    };
    initContent = lib.mkOrder 1000 zshrc;
  };
}
