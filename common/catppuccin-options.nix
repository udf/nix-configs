{
  lib,
  pkgs,
  inputs,
  blackBackground ? false,
}:
let
  colorOverrides = {
    mocha =
      (lib.optionalAttrs blackBackground {
        base = "000000";
      })
      // {
        # mantle = "010101";
        # crust = "020202";
      };
  };

  prefixedColorOverrides = lib.mapAttrs (
    _flavor: overrides: lib.mapAttrs (_name: value: "#${value}") overrides
  ) colorOverrides;

  paletteJqFilter =
    let
      toJSON = builtins.toJSON;
      assignments = lib.flatten (
        lib.mapAttrsToList (
          flavor: overrides:
          lib.mapAttrsToList (
            name: value: ".[${toJSON flavor}].colors[${toJSON name}].hex = ${toJSON value}"
          ) overrides
        ) prefixedColorOverrides
      );
    in
    if assignments == [ ] then "." else lib.concatStringsSep " | " assignments;

  hostPlatform = pkgs.stdenv.hostPlatform.system;
in
rec {
  inherit colorOverrides prefixedColorOverrides;

  sources = inputs.catppuccin.packages.${hostPlatform}.overrideScope (
    final: prev: {
      palette = pkgs.runCommand "catppuccin-palette-overridden" { nativeBuildInputs = [ pkgs.jq ]; } ''
        mkdir -p "$out"
        jq ${lib.escapeShellArg paletteJqFilter} \
          ${lib.escapeShellArg "${prev.palette}/palette.json"} \
          > "$out/palette.json"
      '';

      whiskers = pkgs.symlinkJoin {
        name = "whiskers-wrapped";

        paths = [ prev.whiskers ];
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

        postBuild = ''
          wrapProgram $out/bin/whiskers \
            --add-flag ${lib.escapeShellArg "--color-overrides=${builtins.toJSON colorOverrides}"}
        '';

        meta.mainProgram = "whiskers";
      };
    }
  );

  flavor = "mocha";
  accent = "mauve";

  palette = (lib.importJSON "${sources.palette}/palette.json").${flavor}.colors;
}
