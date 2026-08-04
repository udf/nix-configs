{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  catppuccinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit lib pkgs inputs;
  };

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
