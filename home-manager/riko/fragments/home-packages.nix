{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xpra
    vesktop
    # node
    nodejs
    prettier
    eslint
  ];
}
