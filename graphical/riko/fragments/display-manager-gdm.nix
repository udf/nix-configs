{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
  ];

  systemd.tmpfiles.rules =
    let
      username = "sam";
    in
    [
      "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\n"
      "L+ /var/lib/AccountsService/icons/${username} - - - - ${../assets/jill-face.png}"
    ];

  services.displayManager.gdm = {
    enable = true;
  };
}
