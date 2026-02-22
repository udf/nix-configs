{ config, ... }:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  services.playerctld.enable = true;

  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "XF86AudioPlay" = "exec playerctl -p playerctld play-pause";
        "XF86AudioNext" = "exec playerctl -p playerctld next";
        "XF86AudioPrev" = "exec playerctl -p playerctld prev";

        "${mod}+XF86AudioRaiseVolume" = "exec playerctl -p playerctld position 2+";
        "${mod}+XF86AudioLowerVolume" = "exec playerctl -p playerctld position 2-";

        "${mod}+Ctrl+XF86AudioRaiseVolume" = "exec playerctl -p playerctld volume 0.01+";
        "${mod}+Ctrl+XF86AudioLowerVolume" = "exec playerctl -p playerctld volume 0.01-";

        "--release ${mod}+XF86AudioNext" = "exec playerctld shift";
        "--release ${mod}+XF86AudioPrev" = "exec playerctld unshift";

        "${mod}+Mod1+s" = "exec playerctl -p playerctld play-pause";
        "${mod}+Mod1+x" = "exec playerctl -p playerctld next";
        "${mod}+Mod1+z" = "exec playerctl -p playerctld prev";

        "${mod}+Mod1+f" = "exec playerctl -p playerctld volume 0.01+";
        "${mod}+Mod1+v" = "exec playerctl -p playerctld volume 0.01-";

        "--release ${mod}+Mod1+w" = "exec playerctld shift";
        "--release ${mod}+Mod1+q" = "exec playerctld unshift";
      };
    };
  };
}
