{ lib }:
let
  colorOverrides = {
    mocha = {
      # TODO: this might be too dark, probably want to use a dimmed default instead of pure black
      base = "000000";
      # mantle = "010101";
      # crust = "020202";
    };
  };
in
{
  inherit colorOverrides;

  prefixedColorOverrides = lib.mapAttrs (
    _flavor: overrides: lib.mapAttrs (_name: value: "#${value}") overrides
  ) colorOverrides;

  flavor = "mocha";
  accent = "mauve";
}
