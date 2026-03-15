{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = { };
    extraConfig = builtins.readFile ./config;
  };
}
