{ config, pkgs, ... }:
{
  services.mpd-ratings-sync = {
    enable = true;
    ratingsDBDir = "${config.home.homeDirectory}/.config/mpd/ratings_sync";
    mpdStickerDBPath = "${config.home.homeDirectory}/.config/mpd/sticker.sql";
  };
}
