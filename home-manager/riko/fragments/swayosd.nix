{
  config,
  lib,
  pkgs,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  osdNotify = pkgs.writeShellScriptBin "osd-notify.sh" ''
    if [ "$#" -lt 2 ]; then
      echo "Usage: $0 icon message [progress]"
      exit 1
    fi

    ARGS=()

    if [ -n "$1" ]; then
      ARGS+=("--custom-icon" "$1")
    fi

    TEXT_ARG="--custom-message"
    if [ -n "$3" ]; then
      if [[ $3 == *:* ]]; then
        ARGS+=("--custom-segmented-progress" "$3")
      else
        ARGS+=("--custom-progress" "$3")
      fi
      TEXT_ARG="--custom-progress-text"
    fi

    if [ -n "$2" ]; then
      ARGS+=("$TEXT_ARG" "$2")
    fi

    ${lib.getExe' config.services.swayosd.package "swayosd-client"} "''${ARGS[@]}"
  '';
in
{
  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  home.packages = [ osdNotify ];

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
