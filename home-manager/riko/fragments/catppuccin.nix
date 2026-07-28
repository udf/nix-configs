{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  catppucinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit
      lib
      pkgs
      inputs
      ;
  };
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = catppucinOptions.flavor;
    accent = catppucinOptions.accent;

    cursors.enable = false;
    vscodium.profiles.default.enable = false;
    kvantum.apply = true;
    gtk.icon.enable = true;

    sources = catppucinOptions.sources;
  };
}
