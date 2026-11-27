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
      nixpkgs = inputs.nixpkgs;
      forSystems =
        systems: function: lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});
      mkConfig =
        {
          hostName,
          hostDir,
          flake,
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
            hostFlakePath = "./${hostDir}";
            customUtils = customUtils;
          };
          modules = [
            (./. + "/${hostDir}/configuration.nix")
            {
              nix.nixPath = [
                "nixpkgs=${pkgs}"
              ];
              networking.hostName = hostName;
            }
            inputs.nix-index-database.nixosModules.default
          ]
          ++ extraModules
          ++ lib.optionals (home-manager != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = allInputs // {
                inputs = allInputs;
                customUtils = customUtils;
                hmRootPath = ./graphical/_home-manager;
              };
              home-manager.sharedModules = extraHomeManagerModules;
            }
          ];
        };
    in
    {
      nixosConfigurations =
        lib.mapAttrs
          (
            hostName: hostDir:
            mkConfig {
              inherit hostName hostDir;
              flake = inputs.${hostName};
            }
          )
          {
            ananke = "headless/ananke";
            durga = "headless/durga";
            phanes = "headless/phanes";
            riko = "graphical/riko";
          };

      devShells = forSystems [ "x86_64-linux" ] (
        pkgs:
        let
          pythonPkg = pkgs.python3.withPackages (
            _: with pkgs.python3Packages; [
              (pkgs.python3Packages.callPackage inputs.riko.inputs.snirid.lib.snirid { })
              dbus-fast
            ]
          );
        in
        {
          default = pkgs.mkShell {
            shellHook = ''
              export NIX_PYTHON_PATH="${lib.getExe pythonPkg}"
            '';

            packages = [ pythonPkg ];
          };
        }
      );
    };
}
