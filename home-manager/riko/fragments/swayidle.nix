{
  pkgs,
  config,
  lib,
  ...
}:
let
  systemctl = "${pkgs.systemd}/bin/systemctl";
  lockCmd = "${systemctl} start --no-block --user swaylock";
  lockIsActive = "${systemctl} --user is-active swaylock";
  kbdBacklightCmd =
    level: "${lib.getExe config.namedPackages.kbd-backlight} --silent ${toString level}";
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  displays = status: "${swaymsg} 'output * power ${status}' > /dev/null";
  dimScreen =
    duration:
    "${lib.getExe (pkgs.callPackage ../packages/dim-screen.nix { })} --duration ${toString duration}";
in
{
  services.swayidle = {
    enable = true;
    extraArgs = [ ];
    timeouts = [
      {
        timeout = 20;
        command = "${lockIsActive} && ${displays "off"} && ${kbdBacklightCmd 0}";
        resumeCommand = "${displays "on"} && ${kbdBacklightCmd 1}";
      }
      {
        timeout = 115;
        command = "${pkgs.libnotify}/bin/notify-send 'Session will be locked soon' -t 5000";
      }
      {
        timeout = 115;
        command = "${dimScreen 5}";
      }
      {
        timeout = 120;
        command = lockCmd;
      }
      {
        timeout = 125;
        command = "${kbdBacklightCmd 0}; ${displays "off"}";
        resumeCommand = "${kbdBacklightCmd 1}; ${displays "on"}";
      }
      {
        timeout = 300;
        command = "${lib.getExe' pkgs.systemd "systemd-ac-power"} || ${systemctl} suspend";
      }
    ];
    events = {
      "before-sleep" = "${lockCmd}; ${lib.getExe pkgs.playerctl} --all-players pause";
      "after-resume" = displays "on";
      "lock" = lockCmd;
    };
  };
}
