{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # tools
    gcc
    hyperfine

    # graphical editors
    gimp
    inkscape
    kdePackages.kdenlive
    aegisub

    # chat
    vesktop
    telegram-desktop
    signal-desktop

    # node
    nodejs
    prettier
    eslint

    # power
    acpi
    powertop
  ];
}
