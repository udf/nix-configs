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
  python = pkgs.python3.withPackages (_: [ sniri ]);
in
{
  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "focus-recent-urgent.kdl";
      text = ''
        binds {
          Mod+Z { spawn "systemctl" "--user" "kill" "-s" "SIGUSR1" "niri-recent-urgent.service"; }
        }
      '';
    })
  ];

  systemd.user.services.niri-recent-urgent = {
    Unit = {
      Description = "Focus the most recently urgent Niri window";
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
      ExecStart = "${lib.getExe python} ${./niri-recent-urgent.py}";
    };
  };
}
