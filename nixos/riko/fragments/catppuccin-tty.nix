{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  catppucinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit
      lib
      pkgs
      inputs
      ;
    blackBackground = true;
  };
  paletteHex = colour: catppucinOptions.palette.${colour}.hex;

  red = paletteHex "red";
  green = paletteHex "green";
  yellow = paletteHex "yellow";
  blue = paletteHex "blue";
  pink = paletteHex "pink";
  teal = paletteHex "teal";

  darken = inputs.nix-colorizer.hex.darken;
  mkDark = colorHex: darken colorHex 0.12;
in
{
  catppuccin.tty.enable = false;

  console.colors = map (colorHex: (lib.removePrefix "#" colorHex)) [
    (paletteHex "base")
    (mkDark red)
    (mkDark green)
    (mkDark yellow)
    (mkDark blue)
    (mkDark pink)
    (mkDark teal)
    (paletteHex "subtext0")

    (paletteHex "surface2")
    red
    green
    yellow
    blue
    pink
    teal
    (paletteHex "text")
  ];
}
