{
  description = "Sam's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Third party sources
    # MARK: pinned version
    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit/948aa87003f6c94080650804a6974182e5948ca1";
    catppuccin.url = "github:catppuccin/nix";
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
          extraModules ? [ ],
          extraHomeManagerModules ? [ ],
        }:
        pkgs.lib.nixosSystem {
          system = null;
          specialArgs = { inherit inputs; };
          modules = [
            (./. + "/nixos/${host}/configuration.nix")
            {
              nix.nixPath = [
                "nixpkgs=${pkgs}"
              ];
              networking.hostName = host;
            }
            inputs.nix-index-database.nixosModules.default
          ]
          ++ extraModules
          ++ lib.optionals (home-manager != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = extraHomeManagerModules;
            }
          ];
        };
    in
    {
      nixosConfigurations = mapAttrs mkConfig {
        riko = {
          pkgs = inputs.nixpkgs-unstable;
          home-manager = inputs.home-manager-unstable;
          extraModules = [ inputs.catppuccin.nixosModules.catppuccin ];
          extraHomeManagerModules = [ inputs.catppuccin.homeModules.catppuccin ];
        };
        ananke = {
          pkgs = inputs.nixpkgs;
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
