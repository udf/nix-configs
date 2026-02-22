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
}
