{
  lib,
  pkgs,
  nix-colorizer,
  catppuccin,
  ...
}:
let
  mkPalette =
    blackBackground:
    let
      colorOverrides.mocha = (
        lib.optionalAttrs blackBackground {
          base = "#000000";
          mantle = "#101010";
          crust = "#202020";
        }
      );

      prefixedColorOverrides = lib.mapAttrs (
        _flavor: overrides:
        lib.mapAttrs (_name: value: if lib.hasPrefix "#" value then value else "#${value}") overrides
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
      darken = nix-colorizer.hex.darken;
      lighten = nix-colorizer.hex.lighten;

      mkDark = colorHex: darken colorHex 0.12;
      mkLight = colorHex: lighten colorHex 0.12;
      mkSaturated =
        with nix-colorizer;
        color: amount:
        let
          c = hex.to.oklch color;
        in
        oklch.to.hex (c // { C = c.C + amount; });

      originalSources = catppuccin.packages.${hostPlatform};
      paletteSource = originalSources.palette.src or null;

      sources = originalSources.overrideScope (
        final: prev: {
          palette =
            pkgs.runCommand "catppuccin-palette-overridden"
              {
                nativeBuildInputs = [ pkgs.jq ];
              }
              ''
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
      paletteHex = lib.mapAttrs (_name: color: color.hex) palette;
      paletteHexExtra = lib.listToAttrs (
        map
          (name: {
            name = "dark${lib.toSentenceCase name}";
            value = mkDark paletteHex.${name};
          })
          [
            "rosewater"
            "flamingo"
            "pink"
            "mauve"
            "red"
            "maroon"
            "peach"
            "yellow"
            "green"
            "teal"
            "sky"
            "sapphire"
            "blue"
            "lavender"
          ]
      );
      accentColourHex = paletteHex.${accent};
    in
    {
      inherit
        accent
        accentColourHex
        colorOverrides
        flavor
        mkDark
        mkLight
        mkSaturated
        palette
        paletteHex
        paletteHexExtra
        prefixedColorOverrides
        sources
        paletteSource
        ;
    };

  normal = mkPalette false;
  black = mkPalette true;

  paletteOptions = {
    flavor = lib.mkOption {
      type = lib.types.str;
      description = "Catppuccin flavor used by the palette.";
    };
    accent = lib.mkOption {
      type = lib.types.str;
      description = "Catppuccin accent used by the palette.";
    };
    sources = lib.mkOption {
      type = lib.types.attrs;
      description = "Catppuccin package sources and theme assets.";
    };
    paletteSource = lib.mkOption {
      type = lib.types.nullOr lib.types.raw;
      description = "The upstream Catppuccin palette source output.";
    };
    colorOverrides = lib.mkOption {
      type = lib.types.attrs;
      description = "Catppuccin palette overrides passed to tools and templates.";
    };
    prefixedColorOverrides = lib.mkOption {
      type = lib.types.attrs;
      description = "Palette overrides with hexadecimal color prefixes.";
    };
    palette = lib.mkOption {
      type = lib.types.attrs;
      description = "Selected Catppuccin palette metadata.";
    };
    paletteHex = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Selected Catppuccin colors as hexadecimal strings.";
    };
    paletteHexExtra = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Darkened Catppuccin palette colors.";
    };
    accentColourHex = lib.mkOption {
      type = lib.types.str;
      description = "Selected Catppuccin accent color.";
    };
    mkDark = lib.mkOption {
      type = lib.types.raw;
      description = "Darken a hexadecimal color.";
    };
    mkLight = lib.mkOption {
      type = lib.types.raw;
      description = "Lighten a hexadecimal color.";
    };
    mkSaturated = lib.mkOption {
      type = lib.types.raw;
      description = "Adjust a hexadecimal color toward higher saturation.";
    };
  };

  paletteSubmodule = lib.types.submodule {
    options = paletteOptions;
  };
in
{
  options.custom.catppuccin = lib.mkOption {
    type = lib.types.submodule {
      options = paletteOptions // {
        black = lib.mkOption {
          type = paletteSubmodule;
          description = "Catppuccin values with a true-black base color.";
        };
      };
    };
    description = "Catppuccin configuration and palette values.";
  };

  config = {
    custom.catppuccin = normal // {
      inherit black;
    };

    system.extraDependencies = [
      normal.sources.palette
    ]
    ++ lib.optionals (normal.paletteSource != null) [ normal.paletteSource ];
  };
}
