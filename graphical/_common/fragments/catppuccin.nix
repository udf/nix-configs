{
  inputs,
  lib,
  pkgs,
  ...
}@args:
let
  catppuccinOptions = import (inputs.self + "/common/helpers/catppuccin-options.nix") args;
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    inherit (catppuccinOptions) flavor accent sources;
  };
}
