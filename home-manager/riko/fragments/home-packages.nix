{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xpra
    vesktop
    gimp

    # node
    nodejs
    prettier
    eslint
  ];
}
