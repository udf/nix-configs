{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  catppuccinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit lib pkgs inputs;
    blackBackground = true;
  };
  inherit (catppuccinOptions) paletteHex paletteHexExtra;
in
{
  catppuccin.tty.enable = false;

  console.colors = map (colorHex: (lib.removePrefix "#" colorHex)) [
    paletteHex.base
    paletteHexExtra.darkRed
    paletteHexExtra.darkGreen
    paletteHexExtra.darkYellow
    paletteHexExtra.darkBlue
    paletteHexExtra.darkPink
    paletteHexExtra.darkTeal
    paletteHex.subtext0

    paletteHex.surface2
    paletteHex.red
    paletteHex.green
    paletteHex.yellow
    paletteHex.blue
    paletteHex.pink
    paletteHex.teal
    paletteHex.text
  ];
}
