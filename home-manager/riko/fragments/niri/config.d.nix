{
  lib,
  ...
}:
let
  kdlNames = lib.filter (name: lib.hasSuffix ".kdl" name) (
    lib.attrNames (builtins.readDir ./config.d)
  );
  kdlPaths = map (name: "${./config.d}/${name}") kdlNames;
in
{
  custom.niri.extraConfigFiles = kdlPaths;
}
