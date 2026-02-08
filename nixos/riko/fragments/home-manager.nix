{ config, ... }:
{
  imports = [ <home-manager/nixos> ];
  home-manager.users.sam = import ../../../home-manager/riko/home.nix;
}
