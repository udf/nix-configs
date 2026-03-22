{
  description = "Home Manager configuration for Sam's non-NixOS machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (lib.attrsets) mapAttrs';
      mkConfig =
        host:
        {
          pkgs,
          home-manager,
          modules ? [ ],
        }:
        {
          name = "sam@${host}";
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = modules ++ [
              (./. + "/${host}/home.nix")
            ];
          };
        };
    in
    {
      homeConfigurations = mapAttrs' mkConfig {
        karen-chan = {
          pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
          home-manager = inputs.home-manager;
        };
      };
    };
}
