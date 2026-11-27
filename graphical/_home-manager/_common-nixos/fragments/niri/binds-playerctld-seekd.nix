{
  config,
  pkgs,
  ...
}:
let
  socketPath = "/run/user/${toString config.home.uid}/playerctld-seekd.sock";
in
{
  home.packages = [ pkgs.socat ];
  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-playerctld-seekd.kdl";
      text = ''
        binds {
          Mod+XF86AudioRaiseVolume { write-to-socket "${socketPath}" "2000000"; }
          Mod+XF86AudioLowerVolume { write-to-socket "${socketPath}" "-2000000"; }
          Mod+Alt+TouchpadScrollLeft { write-to-socket "${socketPath}" "1000000"; }
          Mod+Alt+TouchpadScrollRight { write-to-socket "${socketPath}" "-1000000"; }
        }
      '';
    })
  ];
}
