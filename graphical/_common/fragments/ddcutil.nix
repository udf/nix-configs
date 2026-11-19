{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.ddcutil
  ];

  hardware.i2c.enable = true;
  users.users.sam.extraGroups = [ "i2c" ];
}
