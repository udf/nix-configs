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
      kdePackages.kate
      (vscodium.fhsWithPackages (
        ps: with ps; [
          nixfmt
          nil
        ]
      ))
    ];
  };
}
