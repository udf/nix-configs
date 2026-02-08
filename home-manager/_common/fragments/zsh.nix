{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  zshrc = (import ../../../nixos/_common/fragments/zsh/zshrc.nix) { inherit lib pkgs; };
  cfg = config.programs.zsh-config;
in
{
  options.programs.zsh-config.enable = mkOption {
    default = true;
    description = "Enable adding zsh config based on nixos system configs";
    type = lib.types.bool;
  };

  config = mkIf cfg.enable {
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
      completionInit = "";
      envExtra = "skip_global_compinit=1";
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
  };
}
