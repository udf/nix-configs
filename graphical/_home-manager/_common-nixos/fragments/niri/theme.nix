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
  layoutMetrics = rec {
    focusRing = 3;
    gaps = 7;
    verticalGaps = 2;
    tabActualGap = 1;
    tabGap = focusRing + tabActualGap;
    struts = {
      left = -gaps + focusRing;
      right = -gaps + focusRing;
      top = -gaps + focusRing + verticalGaps;
      bottom = -gaps + focusRing + verticalGaps;
    };
  };
in
{
  custom.niri.extraConfigFiles = lib.mkAfter [
    (pkgs.writeTextFile {
      name = "catppuccin-colours.kdl";
      text = ''
        layout {
          gaps ${toString layoutMetrics.gaps}

          struts {
            left ${toString layoutMetrics.struts.left}
            right ${toString layoutMetrics.struts.right}
            top ${toString layoutMetrics.struts.top}
            bottom ${toString layoutMetrics.struts.bottom}
          }

          background-color "${paletteHex.surface1}"
          fullscreen-backdrop-color "#00000080"

          focus-ring {
            width ${toString layoutMetrics.focusRing}
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
            gap ${toString layoutMetrics.tabGap}
            width 8
            corner-radius 4
            position "top"
            gaps-between-tabs 2
            length total-proportion=1.0
            hide-when-single-tab
            place-within-column
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
            spread ${toString layoutMetrics.focusRing}
            offset x=0 y=0
            color "${urgentColour}"
          }
        }
      '';
    })
  ];
}
