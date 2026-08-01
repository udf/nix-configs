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
        sddm.fprintAuth = false;
      };
    };
  };

  services.displayManager.defaultSession = "sway";
  services.displayManager.sessionPackages = [ pkgs.sway ];
  services.displayManager.sddm.enable = true;
}
