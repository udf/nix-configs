{
  config,
  lib,
  pkgs,
  ...
}:
let
  getNamedBin = name: (lib.getExe config.namedPackages."${name}");
in
{
  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-mpd-scripts.kdl";
      text = ''
        binds {
          Mod+Alt+a repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 8"; }
          Mod+Alt+Shift+a repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 10"; }
          Mod+Alt+space repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 2 --go-next"; }
          XF86AudioStop repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 8"; }
          Shift+XF86AudioStop repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 10"; }
          Shift+XF86AudioNext repeat=false { spawn-sh "${getNamedBin "mpd-set-current-rating"} 2 --go-next"; }
          Mod+Delete repeat=false { spawn-sh "${getNamedBin "mpd-q-pop"}"; }
        }
      '';
    })
  ];
}
