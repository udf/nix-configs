{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  sniri = pkgs.python3Packages.callPackage (
    inputs.self + /graphical/_home-manager/_common-nixos/packages/sniri
  ) { };
  python = pkgs.python3.withPackages (
    _: with pkgs.python3Packages; [
      sniri
      dbus-fast
    ]
  );
in
{
  systemd.user.services.niri-auto-power-profile = {
    Unit = {
      Description = "Sets power profiles based on currently focused window";
      After = [
        "niri.service"
        config.wayland.systemd.target
      ];
      Wants = [ "niri.service" ];
      PartOf = [ config.wayland.systemd.target ];
      Requisite = [ config.wayland.systemd.target ];
      ConditionEnvironment = [
        "WAYLAND_DISPLAY"
        "NIRI_SOCKET"
      ];
    };

    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };

    Service = {
      Environment = [ "PYTHONUNBUFFERED=1" ];
      Type = "simple";
      Restart = "always";
      ExecStart = "${lib.getExe python} ${./niri-auto-power-profile.py}";
    };
  };
}
