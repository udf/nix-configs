{
  pkgs,
  ...
}:
{
  services.xserver.enable = true;

  programs.sway = {
    enable = true;
    package = null;
    wrapperFeatures.gtk = true;
  };

  security = {
    pam = {
      services = {
        greetd.enableGnomeKeyring = true;
      };
    };
  };

  services.displayManager.defaultSession = "sway";
  services.displayManager.sessionPackages = [ pkgs.sway ];
  services.displayManager.gdm.enable = true;
}
