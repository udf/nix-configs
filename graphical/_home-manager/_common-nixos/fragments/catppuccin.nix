{
  lib,
  pkgs,
  inputs,
  ...
}@args:
let
  catppuccinOptions = import (inputs.self + "/common/helpers/catppuccin-options.nix") args;

in
{
  catppuccin = {
    enable = true;
    autoEnable = true;

    cursors.enable = false;
    vscodium.profiles.default.enable = false;
    kvantum.apply = true;
    gtk.icon.enable = true;

    inherit (catppuccinOptions) flavor accent sources;
  };
}
