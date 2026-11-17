{ config, pkgs, ... }:
{
  users.users.sam = {
    isNormalUser = true;
    description = "sam";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
