{
  config,
  lib,
  pkgs,
  ...
}:
let
  socat = lib.getExe pkgs.socat;
  echo = lib.getExe' pkgs.coreutils "echo";
  seekCmd = offset: ''
    "${socat}" "-u" "EXEC:${echo} ${offset}" "UNIX-CONNECT:/run/user/${toString config.home.uid}/playerctld-seekd.sock";
  '';
in
{
  home.packages = [ pkgs.socat ];

  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-playerctld-seekd.kdl";
      text = ''
        binds {
          Mod+XF86AudioRaiseVolume { spawn ${seekCmd "2000000"} }
          Mod+XF86AudioLowerVolume { spawn ${seekCmd "-2000000"} }
          Mod+Alt+TouchpadScrollLeft { spawn ${seekCmd "1000000"} }
          Mod+Alt+TouchpadScrollRight { spawn ${seekCmd "-1000000"} }
        }
      '';
    })
  ];
}
