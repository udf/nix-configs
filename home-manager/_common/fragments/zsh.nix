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
    initContent = lib.mkMerge [
      (lib.mkOrder 1000 zshrc)
      (lib.mkOrder 1001 ''
        # Add scripts directory to path
        export PATH="$HOME/scripts:$PATH"

        # Add npm package binaries to path
        export PATH="$HOME/.npm-packages/bin:$PATH"
      '')
    ];
  };
}
