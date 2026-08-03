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
  };
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = catppucinOptions.flavor;
    accent = catppucinOptions.accent;
    sources = catppucinOptions.sources;
  };
}
