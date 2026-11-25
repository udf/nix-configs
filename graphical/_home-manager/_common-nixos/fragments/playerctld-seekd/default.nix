{
  lib,
  pkgs,
  ...
}:
let
  python = pkgs.python3.withPackages (
    _: with pkgs.python3Packages; [
      dbus-fast
    ]
  );
in
{
  systemd.user.services.playerctld-seekd = {
    Unit = {
      Description = "Batched playerctld seek daemon";
      After = [ "playerctld.service" ];
      Requisite = [ "playerctld.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Environment = [
        "PYTHONUNBUFFERED=1"
        "PLAYERCTLD_SEEK_SOCKET=%t/playerctld-seekd.sock"
      ];
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      ExecStart = "${lib.getExe python} ${./playerctld-seekd.py}";
    };
  };
}
