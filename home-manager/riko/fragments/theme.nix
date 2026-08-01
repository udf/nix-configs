{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  catppucinOptions = import (inputs.self + "/common/catppuccin-options.nix") {
    inherit
      lib
      pkgs
      inputs
      ;
  };
in
{
  home.pointerCursor = {
    enable = true;
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
    adwaita-icon-theme
    config.gtk.iconTheme.package
    config.gtk.theme.package
    kdePackages.qtstyleplugin-kvantum
  ];

  gtk = {
    colorScheme = "dark";
    enable = true;
    theme = {
      name = "catppuccin-${catppucinOptions.flavor}-${catppucinOptions.accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ catppucinOptions.accent ];
        variant = catppucinOptions.flavor;
      };
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
    gtk4.theme = config.gtk.theme;
  };

  home.sessionVariables = {
    GTK_THEME = config.gtk.theme.name;
  };

  qt =
    let
      qtctSettings = {
        Appearance = {
          style = "kvantum";
          icon_theme = config.gtk.iconTheme.name;
        };
        Fonts = {
          # TODO: maybe use Adwaita Sans?
          general = ''"Roboto,11"'';
          fixed = ''"Hack Nerd Font,10"'';
        };
      };
    in
    {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
      qt5ctSettings = qtctSettings;
      qt6ctSettings = qtctSettings;
    };
}
