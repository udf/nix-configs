{ config, pkgs, ... }:
{
  users.users.sam = {
    isNormalUser = true;
    description = "sam";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      (vscodium.fhsWithPackages (
        ps: with ps; [
          nixfmt
          nixd
        ]
      ))
    ];
  };
}
