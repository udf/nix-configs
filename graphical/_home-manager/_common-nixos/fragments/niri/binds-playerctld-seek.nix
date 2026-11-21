{
  lib,
  pkgs,
  ...
}:
let
  playerctld-seek = pkgs.callPackage ../../packages/playerctld-seek { };
in
{
  home.packages = [ playerctld-seek ];

  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-playerctld-seek.kdl";
      text = ''
        binds {
          Mod+XF86AudioRaiseVolume { spawn "${lib.getExe playerctld-seek}" "2000000"; }
          Mod+XF86AudioLowerVolume { spawn "${lib.getExe playerctld-seek}" "-2000000"; }
          Mod+Alt+TouchpadScrollLeft { spawn "${lib.getExe playerctld-seek}" "2000000"; }
          Mod+Alt+TouchpadScrollRight { spawn "${lib.getExe playerctld-seek}" "-2000000"; }
        }
      '';
    })
  ];
}
