{ config, pkgs, ... }:
{
  services.mpdris2 = {
    enable = true;
    mpd = {
      host = "localhost";
      port = 6600;
      musicDirectory = "/music";
    };
  };
}
