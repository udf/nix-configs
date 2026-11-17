{ pkgs, ... }: {
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
    XDG_DESKTOP_PORTAL_FILE_CHOOSER = "kde";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      config.common = {
        default = [
          "wlr"
          "kde"
        ];
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      };
    };
  };
}
