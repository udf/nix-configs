{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    mpc
    cantata
    pcmanfm-qt
  ];

  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = "${config.home.homeDirectory}/music";
    playlistDirectory = config.services.mpd.musicDirectory;
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    extraConfig = ''
      auto_update "yes"
      max_output_buffer_size "262144"
      restore_paused "yes"

      audio_output {
        type "pipewire"
        name "MPD"
      }

      replaygain "track"
      filesystem_charset "UTF-8"
    '';
  };

  services.mpdris2.enable = true;

  services.mpd-ratings-sync = {
    enable = true;
    ratingsDBDir = "${config.services.mpd.dataDir}/ratings_sync";
    mpdStickerDBPath = "${config.services.mpd.dataDir}/sticker.sql";
  };
}
