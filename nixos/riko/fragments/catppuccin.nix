{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  catppucinOptions = import (inputs.self + "/common/catppuccin-options.nix") { inherit lib; };
  hostPlatform = pkgs.stdenv.hostPlatform.system;
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = catppucinOptions.flavor;
    accent = catppucinOptions.accent;
    sources = inputs.catppuccin.packages.${hostPlatform}.overrideScope (
      final: prev: {
        whiskers = pkgs.symlinkJoin {
          name = "whiskers-wrapped";

          paths = [ prev.whiskers ];
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

          postBuild = ''
            wrapProgram $out/bin/whiskers \
              --add-flag ${lib.escapeShellArg "--color-overrides=${builtins.toJSON catppucinOptions.colorOverrides}"}
          '';

          meta.mainProgram = "whiskers";
        };
      }
    );
  };
}
