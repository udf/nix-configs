{ config, ... }:
{
  home-manager.users.sam = import ../../../home-manager/riko/home.nix;
}
