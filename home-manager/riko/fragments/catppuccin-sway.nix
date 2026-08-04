{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  catppuccinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit lib pkgs inputs;
  };
  inherit (catppuccinOptions) accent;
in
{
  wayland.windowManager.sway.config.colors =
    let
      accentColour = "$" + accent;
      urgentColor = "$red";
      indicatorColour = "$peach";
    in
    {
      focused = {
        border = accentColour;
        background = accentColour;
        text = "$base";
        indicator = indicatorColour;
        childBorder = accentColour;
      };
      focusedInactive = {
        border = accentColour;
        background = "$base";
        text = "$text";
        indicator = indicatorColour;
        childBorder = "$overlay0";
      };
      unfocused = {
        border = "$overlay0";
        background = "$base";
        text = "$text";
        indicator = indicatorColour;
        childBorder = "$overlay0";
      };
      urgent = {
        border = urgentColor;
        background = urgentColor;
        text = "$base";
        indicator = "$overlay0";
        childBorder = urgentColor;
      };
      placeholder = {
        border = "$overlay0";
        background = "$base";
        text = "$text";
        indicator = "$overlay0";
        childBorder = "$overlay0";
      };
      background = "$base";
    };
}
