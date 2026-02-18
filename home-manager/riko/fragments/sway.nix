{
  config,
  lib,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
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
      window = {
        hideEdgeBorders = "smart_no_gaps";
      };
      keybindings = {
        # window manager management
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";

        # program management
        "${mod}+x" = "kill";

        # programs
        "${mod}+Escape" = "exec swaylock";
        "${mod}+c" = "exec ${swayCfg.config.terminal}";
        "${mod}+d" = "exec ${swayCfg.config.menu}";
        "${mod}+n" = "exec firefox";

        # window management
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+a" = "focus parent";
        "${mod}+Shift+a" = "focus child";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+Ctrl+Left" = "resize shrink width 1 px or 1 ppt";
        "${mod}+Ctrl+Right" = "resize grow width 1 px or 1 ppt";
        "${mod}+Ctrl+Down" = "resize shrink height 1 px or 1 ppt";
        "${mod}+Ctrl+Up" = "resize grow height 1 px or 1 ppt";

        "${mod}+h" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+f" = "fullscreen toggle";

        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+space" = "floating toggle";
        "${mod}+Shift+space" = "focus mode_toggle";

        # workspaces
        "${mod}+Mod1+Left" = "workspace prev_on_output";
        "${mod}+Mod1+Right" = "workspace next_on_output";

        "${mod}+Mod1+Ctrl+Left" = "move container to workspace prev_on_output";
        "${mod}+Mod1+Ctrl+Right" = "move container to workspace next_on_output";

        "${mod}+Mod1+Shift+Left" = "move container to workspace prev_on_output; workspace prev_on_output";
        "${mod}+Mod1+Shift+Right" = "move container to workspace next_on_output; workspace next_on_output";

        # TODO: https://github.com/swaywm/sway/issues/4346
        # "${mod}+grave" = "exec --no-startup-id i3-next-visible-ws";
        # "${mod}+Shift+grave" = "move container to output next; exec --no-startup-id i3-next-visible-ws";
        # "${mod}+Ctrl+grave" = "move container to output next";
        # "${mod}+Mod1+grave" = "move workspace to output next";
      }
      # per workspace keys
      // lib.attrsets.mergeAttrsList (
        lib.lists.forEach (lib.lists.map toString (lib.range 1 9)) (n: {
          "${mod}+${n}" = "workspace ${n}";
          "${mod}+Ctrl+${n}" = "move container to workspace ${n}";
          "${mod}+Shift+${n}" = "move container to workspace ${n}; workspace ${n}";
        })
      );
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
