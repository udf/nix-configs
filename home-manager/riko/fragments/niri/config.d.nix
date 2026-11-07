{
  lib,
  ...
}:
let
  dirContents = builtins.readDir ./config.d;
  kdlFiles = lib.filter (name: lib.hasSuffix ".kdl" name) (lib.attrNames dirContents);
  includes = map (name: "include \"${./config.d}/${name}\";") kdlFiles;
in
{
  wayland.windowManager.niri.extraConfig = builtins.concatStringsSep "\n" includes;
}
