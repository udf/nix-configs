{
  pkgs,
  config,
  lib,
  ...
}:
let
  systemctl = "${pkgs.systemd}/bin/systemctl";
  lockCmd = "${systemctl} start --no-block --user swaylock";
  kbdBacklightCmd = level: "${lib.getExe config.namedPackages.kbd-backlight} ${toString level}";
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  display = status: "${swaymsg} 'output * power ${status}'";
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 20;
        command = "${systemctl} --user is-active swaylock && ${display "off"} && ${kbdBacklightCmd 0}";
        resumeCommand = "${display "on"} && ${kbdBacklightCmd 1}";
      }
      {
        timeout = 50;
        command = "${pkgs.libnotify}/bin/notify-send 'Session will be locked soon' -t 5000";
      }
      {
        timeout = 55;
        command = "${lib.getExe pkgs.chayang} && ${display "off"} && ${lockCmd}";
        resumeCommand = display "on";
      }
      {
        timeout = 65;
        command = kbdBacklightCmd 0;
        resumeCommand = kbdBacklightCmd 1;
      }
      {
        timeout = 300;
        command = "${lib.getExe' pkgs.systemd "systemd-ac-power"} || ${systemctl} suspend";
      }
    ];
    events = {
      "before-sleep" = "${lockCmd}; ${lib.getExe pkgs.playerctl} --all-players pause";
    };
  };
}
