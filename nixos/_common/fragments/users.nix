{ pkgs, ... }:
{
  users.users = {
    sam = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzlWx6yy2nWV8fYcIm9Laap8/KxAlLJd943TIrcldSY archdesktop"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxBxAt/K3h+W4wyxLbTsW0awTIzJy2rpsQgDKxBHNe5 iOS"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbHvYANduDUO7939VJu12KFxMEM5fCRx/4PG/W5UwIa sam@mashiro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXvppyCaen/sIcyxeR/ZRhRhe3/J+8t6f0XFXh/E5b9 sam@riko"
      ];
      uid = 1000;
      packages = [
        pkgs.python3
      ];
    };
  };
}
