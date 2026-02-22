{ config, ... }:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
in
{
  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  wayland.windowManager.sway = {
    config = {
      keybindings = {
        # Audio Volume Controls
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume +1";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume -1";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

        "${mod}+Mod1+d" = "exec swayosd-client --output-volume +2";
        "${mod}+Mod1+c" = "exec swayosd-client --output-volume -2";
        "${mod}+Mod1+e" = "exec swayosd-client --output-volume mute-toggle";

        # Brightness Controls
        "XF86MonBrightnessUp" = "exec swayosd-client --device amdgpu_bl2 --brightness +1";
        "XF86MonBrightnessDown" = "exec swayosd-client --device amdgpu_bl2 --brightness -1";

        # Media Player Controls
        "XF86AudioPlay" = "exec swayosd-client --playerctl --player playerctld play-pause";
        "XF86AudioNext" = "exec swayosd-client --playerctl --player playerctld next";
        "XF86AudioPrev" = "exec swayosd-client --playerctl --player playerctld prev";

        "${mod}+Mod1+s" = "exec swayosd-client --playerctl --player playerctld play-pause";
        "${mod}+Mod1+x" = "exec swayosd-client --playerctl --player playerctld next";
        "${mod}+Mod1+z" = "exec swayosd-client --playerctl --player playerctld prev";
      };
    };
  };
}
