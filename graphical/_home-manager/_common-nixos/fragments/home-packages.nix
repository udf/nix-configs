{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # tools
    ffmpeg
    gcc

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
