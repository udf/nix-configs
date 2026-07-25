{ lib, ... }:

{
  options.custom.pinnedVersions = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf (lib.types.either lib.types.str lib.types.package));
    default = { };
    description = "Pinned versions for various programs, organized by category and name.";
    example = {
      containers = {
        diun = "crazymax/diun:4.31";
      };
      packages = {
        somePackage = "v1.0.0";
      };
    };
  };
}
