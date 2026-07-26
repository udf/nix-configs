{
  pkgs,
  config,
  lib,
  ...
}:
{
  systemd.user.services.screen-locker = {
    Unit = {
      Description = "Screen locker";
      ConditionEnvironment = [
        "WAYLAND_DISPLAY"
      ];
      Requisite = [ config.wayland.systemd.target ];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe config.programs.hyprlock.package;
    };
  };
}
