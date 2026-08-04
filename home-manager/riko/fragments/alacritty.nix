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
  inherit (catppuccinOptions) paletteHexExtra;
in
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics;
    settings = {
      colors.normal = {
        red = paletteHexExtra.darkRed;
        green = paletteHexExtra.darkGreen;
        yellow = paletteHexExtra.darkYellow;
        blue = paletteHexExtra.darkBlue;
        magenta = paletteHexExtra.darkPink;
        cyan = paletteHexExtra.darkTeal;
      };
    };
  };
}
