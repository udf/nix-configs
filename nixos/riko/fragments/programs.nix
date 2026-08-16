{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    gparted-full
    e2fsprogs
    bottles
    bintools
  ];
}
