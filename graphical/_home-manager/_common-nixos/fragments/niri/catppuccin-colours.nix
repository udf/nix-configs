{
  inputs,
  pkgs,
  lib,
  ...
}@args:
let
  catppuccinOptions = import (inputs.self + "/common/helpers/catppuccin-options.nix") args;
  inherit (catppuccinOptions) accentColourHex paletteHex mkSaturated;
  urgentColour = mkSaturated paletteHex.flamingo 0.3;
in
{
  custom.niri.extraConfigFiles = lib.mkAfter [
    (pkgs.writeTextFile {
      name = "catppuccin-colours.kdl";
      text = ''

        layout {
          background-color "${paletteHex.surface0}"
          fullscreen-backdrop-color "#00000080"

          focus-ring {
            width 3
            active-color "${accentColourHex}"
            inactive-color "#00000000"
            urgent-color "${urgentColour}"
          }

          border {
            active-color "${accentColourHex}"
            inactive-color "${paletteHex.surface2}"
            urgent-color "${urgentColour}"
          }

          tab-indicator {
            on
            hide-when-single-tab
            place-within-column
            gap 5
            width 8
            length total-proportion=0.99
            position "left"
            gaps-between-tabs 3
            corner-radius 4
            active-color "${accentColourHex}"
            inactive-color "${paletteHex.surface2}"
            urgent-color "${urgentColour}"
          }

          insert-hint {
            color "${accentColourHex}66"
          }
        }

        // Add red "border" on urgent windows (needed for inactive windows)
        window-rule {
          match is-urgent=true
          shadow {
            on
            softness 0
            spread 3
            offset x=0 y=0
            color "${urgentColour}"
          }
        }
      '';
    })
  ];
}
