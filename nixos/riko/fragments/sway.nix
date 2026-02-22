{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      alacritty-graphics
      wl-clipboard
    ];
  };

  security = {
    pam = {
      services = {
        greetd.enableGnomeKeyring = true;
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
