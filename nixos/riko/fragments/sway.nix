{
  pkgs,
  ...
}:
{
  services.xserver.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;
  };

  programs.sway = {
    enable = true;
    package = null;
    wrapperFeatures.gtk = true;
  };

  security = {
    pam = {
      services = {
        greetd.enableGnomeKeyring = true;
        hyprlock = {
          enable = true;
          fprintAuth = true;
        };
      };
    };
  };

  services.displayManager.defaultSession = "sway";
  services.displayManager.gdm.enable = true;

  services.displayManager.sessionPackages = [ pkgs.sway ];

}
