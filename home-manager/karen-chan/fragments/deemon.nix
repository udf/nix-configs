{ lib, pkgs, ... }:
{
  home.packages = [
    (pkgs.python313Packages.callPackage ../packages/deemon { })
  ];
}
