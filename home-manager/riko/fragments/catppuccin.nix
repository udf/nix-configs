{
  lib,
  pkgs,
  inputs,
  ...
}:
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
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "lavender";

    cursors.enable = false;
    vscodium.profiles.default.enable = false;
    kvantum.apply = true;
    gtk.icon.enable = true;

    sources = inputs.catppuccin.packages.${pkgs.system}.overrideScope (
      final: prev: {
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
  };
}
