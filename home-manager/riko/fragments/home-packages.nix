{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # gui tools
    xpra

    # tools
    ffmpeg

    # graphical editors
    gimp
    inkscape
    kdePackages.kdenlive

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
