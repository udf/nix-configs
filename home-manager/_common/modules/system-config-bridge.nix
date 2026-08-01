{ lib, ... }:
with lib;
{
  options.system = mkOption {
    type = types.lazyAttrsOf types.anything;
    default = { };
    description = "Bridge for NixOS system-level options set from home-manager fragments.";
  };
}
