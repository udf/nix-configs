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
        swaylock = {
          # fingerprint auth is horribly broken in swaylock
          # requiring PAM changes to workaround: https://github.com/swaywm/swaylock/issues/61#issuecomment-965175390
          # however that results in a subpar experience that lacks useful feedback
          # so disable it entirely
          fprintAuth = false;
          enableGnomeKeyring = true;
        };
      };
    };
  };

  services.displayManager.defaultSession = "sway";
  services.displayManager.gdm.enable = true;

  services.displayManager.sessionPackages = [ pkgs.sway ];

}
