{ ... }:
{
  imports = [ ./mpd.nix ];

  services.mpdris2.enable = true;
}
