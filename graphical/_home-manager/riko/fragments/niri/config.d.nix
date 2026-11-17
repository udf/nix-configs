{
  lib,
  pkgs,
  ...
}:
let
  kdlNames = lib.filter (name: lib.hasSuffix ".kdl" name) (
    lib.attrNames (builtins.readDir ./config.d)
  );
  kdlPaths = map (name: "${./config.d}/${name}") kdlNames;
in
{
  imports = [
    # binds-fn-mediakeys.kdl
    ../playerctld.nix

    # binds-programs.kdl
    ../alacritty.nix
  ];

  custom.niri.extraConfigFiles = kdlPaths;

  home.packages = with pkgs; [
    # binds-fn-mediakeys.kdl
    brightnessctl

    # binds-programs.kdl
    fuzzel

    # startup-programs.kdl
    waybar
  ];
}
