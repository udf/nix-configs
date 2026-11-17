{ lib, pkgs, ... }:
{
  home.packages = [
    (pkgs.python3Packages.callPackage ../packages/deemon { })
  ];
}
