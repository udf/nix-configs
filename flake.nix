{
  description = "Sam's NixOS configurations";

  inputs = {
    # MARK: pinned version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # host inputs
    ananke.url = "path:./headless/ananke";
    durga.url = "path:./headless/durga";
    phanes.url = "path:./headless/phanes";
    riko.url = "path:./graphical/riko";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      hostDirs = {
        ananke = "headless/ananke";
        durga = "headless/durga";
        phanes = "headless/phanes";
        riko = "graphical/riko";
      };
      mkConfig =
        {
          host,
          flake,
          hostFlakePath ? "",
        }:
        let
          allInputs = inputs // flake.inputs;
          pkgs = flake.inputs.nixpkgs;
          home-manager = flake.inputs.home-manager or null;
          extraModules = flake.extraModules or [ ];
          extraHomeManagerModules = flake.extraHomeManagerModules or [ ];
          customUtils = (import ./common/injectable/utils.nix) {
            lib = pkgs.lib;
            repoRootPath = ./.;
            repoRealRoot = builtins.readFile ./.root;
          };
        in
        pkgs.lib.nixosSystem {
          system = null;
          specialArgs = allInputs // {
            inputs = allInputs;
            hostFlakePath = hostFlakePath;
            customUtils = customUtils;
          };
          modules = [
            (./. + "/${hostDirs.${host}}/configuration.nix")
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
              home-manager.extraSpecialArgs = {
                inputs = allInputs;
                customUtils = customUtils;
              };
              home-manager.sharedModules = extraHomeManagerModules;
            }
          ];
        };
    in
    {
      nixosConfigurations = lib.genAttrs [ "ananke" "durga" "phanes" "riko" ] (
        h:
        mkConfig {
          host = h;
          flake = inputs.${h};
          hostFlakePath = "./${hostDirs.${h}}";
        }
      );
    };
}
