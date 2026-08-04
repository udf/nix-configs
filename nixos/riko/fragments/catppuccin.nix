{
  inputs,
  lib,
  pkgs,
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
    inherit (catppuccinOptions) flavor accent sources;
  };
}
