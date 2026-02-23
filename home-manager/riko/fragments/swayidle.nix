{
  pkgs,
  config,
  lib,
  ...
}:
let
  lockCmd = "${pkgs.systemd}/bin/systemctl start --no-block --user swaylock";
  swaymsgPath = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  display = status: "${swaymsgPath} 'output * power ${status}'";
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
        command = "${lib.getExe config.namedPackages.kbd-backlight} 0";
        resumeCommand = "${lib.getExe config.namedPackages.kbd-backlight} 1";
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
      "before-sleep" = "${lockCmd}; ${lib.getExe pkgs.playerctl} --all-players pause";
    };
  };
}
