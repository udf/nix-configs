{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # gui tools
    xpra

    # graphics editors
    gimp
    inkscape

    # chat
    vesktop

    # node
    nodejs
    prettier
    eslint
  ];
}
