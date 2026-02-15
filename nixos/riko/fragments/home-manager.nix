{ config, ... }:
{
  imports = [ <home-manager/nixos> ];
  home-manager.users.sam = import ../../../home-manager/riko/home.nix;
  programs.zsh.interactiveShellInit = ''
    . ~"/.nix-profile/etc/profile.d/hm-session-vars.sh"
  '';
}
