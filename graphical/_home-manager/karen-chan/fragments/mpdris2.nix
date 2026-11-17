{ config, pkgs, ... }:
{
  services.mpdris2 = {
    enable = true;
    mpd = {
      host = "localhost";
      port = 6600;
      password = "B7WtKLYaAw7wVf4p";
      musicDirectory = "/booty/music/music/";
    };
  };
}
