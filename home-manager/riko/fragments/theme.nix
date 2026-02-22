{ config, pkgs, ... }:
{
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
    gtk.enable = true;
  };

  gtk = {
    colorScheme = "dark";
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "qtct";
      package = pkgs.kdePackages.qt6ct;
    };
    style.name = "kvantum";

    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = config.gtk.iconTheme.name;
      };
      Fonts = {
        general = ''"Roboto,11"'';
        fixed = ''"Hack,10"'';
      };
    };
  };
}
