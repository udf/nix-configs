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

  home.packages = with pkgs; [
    kdePackages.breeze-icons
  ];

  gtk = {
    colorScheme = "dark";
    enable = true;
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  home.sessionVariables = {
    GTK_THEME = config.gtk.theme.name;
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
        fixed = ''"Hack Nerd Font,10"'';
      };
    };
  };
}
