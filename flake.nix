{
  description = "Sam's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (lib.attrsets) mapAttrs;
      mkConfig =
        host:
        {
          pkgs,
          home-manager ? null,
        }:
        pkgs.lib.nixosSystem {
          system = null;
          modules = [
            (import (./. + "/nixos/${host}/configuration.nix"))
            {
              nix.nixPath = [ "nixpkgs=${pkgs}" ];
              networking.hostName = host;
            }
          ]
          ++ lib.optionals (home-manager != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
    in
    {
      nixosConfigurations = mapAttrs mkConfig {
        riko = {
          pkgs = inputs.nixpkgs-unstable;
          home-manager = inputs.home-manager-unstable;
        };
        ananke = {
          pkgs = inputs.nixpkgs-unstable;
        };
        durga = {
          pkgs = inputs.nixpkgs;
        };
        phanes = {
          pkgs = inputs.nixpkgs;
        };
      };
    };
}
