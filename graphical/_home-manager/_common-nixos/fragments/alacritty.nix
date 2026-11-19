{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (osConfig.custom.catppuccin.black) paletteHexExtra;
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
