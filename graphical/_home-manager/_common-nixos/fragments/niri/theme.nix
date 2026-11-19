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
    border = 3;
    gaps = 4;
    verticalOuterGaps = 2;
    horizontalOuterGaps = 0;
    tabGap = 1;
    struts = {
      left = -gaps + horizontalOuterGaps;
      right = -gaps + horizontalOuterGaps;
      top = -gaps + verticalOuterGaps;
      bottom = -gaps + verticalOuterGaps;
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

          background-color "${paletteHex.surface2}"
          fullscreen-backdrop-color "#00000080"

          focus-ring {
            off
            width ${toString layoutMetrics.border}
            active-color "${accentColourHex}"
            inactive-color "#00000000"
            urgent-color "${urgentColour}"
          }

          border {
            on
            width ${toString layoutMetrics.border}
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
            gaps-between-tabs ${toString layoutMetrics.gaps}
            length total-proportion=0.999
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
      '';
    })
  ];
}
