{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-15 17:00:00";
  };
}
