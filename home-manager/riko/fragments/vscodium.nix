{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  catppuccinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit lib pkgs inputs;
  };
in
{
  programs.vscodium = {
    enable = true;
    package = (
      pkgs.vscodium.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          ${lib.getExe pkgs.jq} \
            '.extensionsGallery = {serviceUrl: "https://marketplace.visualstudio.com/_apis/public/gallery", cacheUrl: "https://vscode.blob.core.windows.net/gallery/index", itemUrl: "https://marketplace.visualstudio.com/items"} | del(.linkProtectionTrustedDomains)' \
            $out/lib/vscode/resources/app/product.json \
            | ${lib.getExe' pkgs.moreutils "sponge"} $out/lib/vscode/resources/app/product.json
        '';
      })
    );
    profiles.default.extensions = [
      (config.catppuccin.sources.vscode.override {
        catppuccinOptions = {
          colorOverrides = catppuccinOptions.prefixedColorOverrides;
        };
      })
    ];
  };

  home.packages = with pkgs; [
    nixfmt
    nixd
  ];
}
