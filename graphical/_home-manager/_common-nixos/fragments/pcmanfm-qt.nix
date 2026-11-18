{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcmanfm-qt
    lxmenu-data
    shared-mime-info
    kdePackages.qtsvg
  ];

  system.services.gvfs.enable = true;
}
