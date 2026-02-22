{
  config,
  lib,
  pkgs,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  getBin = name: (lib.getExe config.namedPackages."${name}");
in
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
      "10" = [
        {
          app_id = "dog.unix.cantata.Cantata";
        }
      ];
    };
    keybindings = {
      "--release ${mod}+Mod1+a" = "exec ${getBin "mpd-set-current-rating"} 8";
      "--release ${mod}+Mod1+Shift+a" = "exec ${getBin "mpd-set-current-rating"} 10";
      "--release ${mod}+Mod1+space" = "exec ${getBin "mpd-set-current-rating"} 2 --go-next";
      "--release XF86AudioStop" = "exec ${getBin "mpd-set-current-rating"} 8";
      "--release Shift+XF86AudioStop" = "exec ${getBin "mpd-set-current-rating"} 10";
      "--release Shift+XF86AudioNext" = "exec ${getBin "mpd-set-current-rating"} 2 --go-next";
      "--release ${mod}+Delete" = "exec ${getBin "mpd-q-pop"}";
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
