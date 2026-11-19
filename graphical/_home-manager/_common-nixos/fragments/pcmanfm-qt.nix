{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcmanfm-qt
    lxmenu-data
    shared-mime-info
    kdePackages.qtsvg
  ];

  systemConfig.services.gvfs.enable = true;
}
