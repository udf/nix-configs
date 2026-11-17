{ config, lib, ... }:
with lib;
let
  cfg = config.namedPackages;
in
{
  options.namedPackages = mkOption {
    type = types.attrsOf types.package;
    default = { };
    description = "Named packages to be added to home.packages";
  };

  config = {
    home.packages = attrValues cfg;
  };
}
