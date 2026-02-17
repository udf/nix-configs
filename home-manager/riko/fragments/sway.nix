{
  config,
  pkgs,
  lib,
  ...
}:
let
  mod = config.wayland.windowManager.sway.config.modifier;
  laptopOutput = "eDP-1";
in
{
  home.pointerCursor.sway.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.variables = [ "--all" ];
    extraConfig = ''
      output * adaptive_sync on
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
      bindswitches = {
        "lid:on" = {
          reload = true;
          locked = true;
          action = "output ${laptopOutput} disable";
        };
        "lid:off" = {
          reload = true;
          locked = true;
          action = "output ${laptopOutput} enable";
        };
      };
    };
  };
}
