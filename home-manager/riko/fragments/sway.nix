{
  config,
  pkgs,
  lib,
  ...
}:
let
  mod = config.wayland.windowManager.sway.config.modifier;
in
{
  home.pointerCursor.sway.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.variables = [ "--all" ];
    extraConfig = ''
      include /etc/sway/config.d/*
    '';
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "firefox"; }
      ];
      keybindings = lib.mkOptionDefault {
        "${mod}+Escape" = "exec swaylock";
      };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          drag_lock = "disabled";
        };
      };
    };
  };
}
