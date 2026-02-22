{ lib, pkgs, ... }:
{
  programs.vscode = {
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
  };

  home.packages = with pkgs; [
    nixfmt
    nixd
  ];
}
