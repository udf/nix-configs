{ config, pkgs, ... }:
{
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
  ];
}
