{
  config,
  lib,
  pkgs,
  ...
}:
{
  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "focus-recent-urgent.kdl";
      text = ''
        binds {
          Mod+Z { spawn-sh "systemctl --user kill -s SIGUSR1 niri-recent-urgent.service"; }
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
      ExecStart = "${lib.getExe pkgs.python3} ${./niri-recent-urgent.py}";
    };
  };
}
