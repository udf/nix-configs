{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # gui tools
    xpra

    # tools
    ffmpeg

    # media
    mpv

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
