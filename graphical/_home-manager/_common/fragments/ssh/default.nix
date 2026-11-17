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
    settings."*" = { };
    extraConfig = builtins.readFile ./config;
  };
}
