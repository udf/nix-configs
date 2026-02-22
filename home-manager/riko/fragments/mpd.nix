{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    mpc
    cantata
    pcmanfm-qt
  ];

  wayland.windowManager.sway.config = {
    startup = [
      { command = "cantata"; }
    ];
    assigns = {
      "9" = [
        {
          app_id = "dog.unix.cantata.Cantata";
        }
      ];
    };
  };

  services.mpd = {
    enable = true;
    network.startWhenNeeded = true;
    musicDirectory = "${config.home.homeDirectory}/music";
    playlistDirectory = config.services.mpd.musicDirectory;
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    extraConfig = ''
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

  services.mpd-ratings-sync = {
    enable = true;
    ratingsDBDir = "${config.services.mpd.dataDir}/ratings_sync";
    mpdStickerDBPath = "${config.services.mpd.dataDir}/sticker.sql";
  };
}
