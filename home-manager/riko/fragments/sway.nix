{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
    sway.enable = true;
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      show-failed-attempts = true;
      effect-scale = "0.5";
      effect-blur = "14x5";
      effect-vignette = "0.5:0.5";
      clock = true;
      indicator = true;
      text-color = "ffffff";
      font = "Hack";
    };
  };

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
