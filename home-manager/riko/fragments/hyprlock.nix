{ ... }: {
  programs.hyprlock = {
    enable = true;
  };
  system.security.pam.services.hyprlock = {
    enable = true;
    fprintAuth = true;
  };
}
