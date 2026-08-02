{
  pkgs,
  ...
}:
{

  security.pam.services = {
    sddm.fprintAuth = false;
    login.fprintAuth = false;
  };

  catppuccin.sddm = {
    userIcon = true;
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/AccountsService/icons/sam - - - - ${../assets/jill-face.png}"
  ];

  environment.systemPackages = [
    pkgs.adwaita-icon-theme
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    extraPackages = [
      pkgs.adwaita-icon-theme
    ];
    settings = {
      Theme = {
        CursorTheme = "Adwaita";
        CursorSize = 24;
      };
    };
  };
}
