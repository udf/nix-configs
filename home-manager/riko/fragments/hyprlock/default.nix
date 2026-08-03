{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  catppucinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit
      lib
      pkgs
      inputs
      ;
  };
  accentColour = catppucinOptions.palette.${catppucinOptions.accent};
  accentColourHex = accentColour.hex;
  accentColorRGBA = "rgba(${lib.removePrefix "#" accentColourHex}ff)";
  backgroundColourHex = catppucinOptions.palette.base.hex;
  hyprlockAccentLineWebp =
    pkgs.runCommandLocal "gray0-ctp-on-line-accent-webp"
      {
        nativeBuildInputs = [
          pkgs.imagemagick
          pkgs.xmlstarlet
        ];
      }
      ''
        set -eu

        mkdir -p "$out/share/"

        cropSvg="$out/share/gray0_ctp_on_line_crop.coloured.svg"
        backgroundLayerXPath="//*[local-name()='g'][@*[local-name()='label']='background']"
        accentLayerXPath="//*[local-name()='g'][@*[local-name()='label']='accent']"

        xmlstarlet ed \
          -u "$backgroundLayerXPath/@style" \
            -v "fill:${backgroundColourHex};stroke:${backgroundColourHex}" \
          -u "$accentLayerXPath/@style" \
            -v "stroke:${accentColourHex};fill:${accentColourHex}" \
          "${./gray0_ctp_on_line_crop.svg}" > "$cropSvg"

        magick -density 1200 -background none "$cropSvg" \
          -resize 1024x \
          -strip \
          -define webp:lossless=true \
          "$out/share/gray0_ctp_on_line_crop.webp"
      '';
in
{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      shape {
        monitor =
        size = 100%, 5.5
        color = ${accentColorRGBA}
        rounding = -1
        border_size = 0
        border_color = rgb(0, 0, 0, 0.0)

        position = 0, -50
        halign = center
        valign = center

        zindex = 0
      }

      image {
        monitor =
        path = ${hyprlockAccentLineWebp}/share/gray0_ctp_on_line_crop.webp
        size = 110
        position = 30%, 0
        border_size = 0
        rounding = 0
        halign = left
        valign = center
        zindex = 1
      }

      auth {
        fingerprint {
          enabled = true
        }
      }
    '';
  };
  system.security.pam.services.hyprlock = {
    enable = true;
    fprintAuth = false;
  };
}
