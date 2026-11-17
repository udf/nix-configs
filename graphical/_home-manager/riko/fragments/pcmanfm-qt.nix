{ config, pkgs, ... }:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  home.packages = with pkgs; [
    pcmanfm-qt
    lxmenu-data
    shared-mime-info
    kdePackages.qtsvg
  ];

  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "${mod}+b" = "exec pcmanfm-qt";
      };
    };
  };
}
