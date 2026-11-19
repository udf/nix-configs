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
          Mod+Alt+A repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "8"; }
          Mod+Alt+Shift+A repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "10"; }
          Mod+Alt+Space repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "2" "--go-next"; }
          XF86AudioStop repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "8"; }
          Shift+XF86AudioStop repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "10"; }
          Shift+XF86AudioNext repeat=false { spawn "${getNamedBin "mpd-set-current-rating"}" "2" "--go-next"; }
          Mod+Delete repeat=false { spawn "${getNamedBin "mpd-q-pop"}"; }
          Mod+Alt+B repeat=false { spawn "${getNamedBin "mpd-q-pop"}"; }
        }
      '';
    })
  ];
}
