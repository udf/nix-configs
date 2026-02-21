{
  pkgs,
  config,
  lib,
  ...
}:
let
  lockCmd = "${lib.getExe config.programs.swaylock.package} --daemonize";
  display =
    status: "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * power ${status}'";
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 55;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 60;
        command = lockCmd;
      }
      {
        timeout = 65;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 300;
        command = "${lib.getExe' pkgs.systemd "systemd-ac-power"} || ${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = {
      "before-sleep" = lockCmd;
    };
  };
}
