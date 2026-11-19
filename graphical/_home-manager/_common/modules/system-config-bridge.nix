{ lib, ... }:
with lib;
{
  options.systemConfig = mkOption {
    type = types.lazyAttrsOf types.anything;
    default = { };
    description = "Bridge for NixOS system-level options set from home-manager fragments.";
  };
}
