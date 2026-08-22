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
    ananke.url = "git+file:./?dir=nixos/ananke";
    durga.url = "git+file:./?dir=nixos/durga";
    phanes.url = "git+file:./?dir=nixos/phanes";
    riko.url = "git+file:./?dir=nixos/riko";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
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
        in
        pkgs.lib.nixosSystem {
          system = null;
          specialArgs = {
            inputs = allInputs;
            hostFlakePath = lib.removePrefix "path:" hostFlakePath;
          };
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
              home-manager.extraSpecialArgs = {
                inputs = allInputs;
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
          hostFlakePath = "./nixos/${h}";
        }
      );
    };
}
