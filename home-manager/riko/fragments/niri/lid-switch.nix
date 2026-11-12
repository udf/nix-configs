{
  config,
  lib,
  pkgs,
  ...
}:
let
  kbdBacklightCmd = lib.getExe config.namedPackages.kbd-backlight;
in
{
  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "lid-switch.kdl";
      text = ''
        switch-events {
          lid-close {
            spawn "sh" "-c" "niri msg output eDP-1 off; ${kbdBacklightCmd} --silent 0";
          }
          lid-open {
            spawn "sh" "-c" "niri msg output eDP-1 on; ${kbdBacklightCmd} --silent 1";
          }
        }
      '';
    })
  ];
}
