{
  lib,
  pkgs,
  hmRootPath,
  osConfig,
  ...
}:
let
  readDirIfExists = dir: if builtins.pathExists dir then builtins.readDir dir else { };
  listKdlPaths =
    dir:
    map (name: "${dir}/${name}") (
      lib.filter (name: lib.hasSuffix ".kdl" name) (lib.attrNames (readDirIfExists dir))
    );
  kdlPaths =
    (listKdlPaths ./config.d) ++ (listKdlPaths (./config.d + "/${osConfig.networking.hostName}"));
in
{
  imports = [
    # binds-fn-mediakeys.kdl
    (hmRootPath + "/_common-nixos/fragments/playerctld.nix")

    # binds-programs.kdl
    (hmRootPath + "/_common-nixos/fragments/alacritty.nix")
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
