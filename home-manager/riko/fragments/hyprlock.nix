{ ... }: {
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      auth {
        fingerprint {
          enabled = true
        }
      }
    '';
  };
  system.security.pam.services.hyprlock = {
    enable = true;
    fprintAuth = false;
  };
}
