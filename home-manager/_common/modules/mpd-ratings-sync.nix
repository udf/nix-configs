{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  pythonPkg = pkgs.python3.withPackages (
    ps: with ps; [
      mpd2
    ]
  );
  pythonPath = "${pythonPkg}/bin/python";
  # TODO: package this
  scriptDir = "${/home/sam/proj/p/mpdratingsync}";
  cfg = config.services.mpd-ratings-sync;
  environmentVars = [
    "PYTHONUNBUFFERED=1"
  ]
  ++ (optionals (cfg.mpdPassword != "") [
    "PASSWORD=${cfg.mpdPassword}"
  ]);
in
{
  options.services.mpd-ratings-sync = {
    enable = mkEnableOption "Enable mpd ratings sync user services";
    ratingsDBDir = mkOption {
      type = types.str;
      description = "The directory where to save/load ratings databases to";
    };
    mpdStickerDBPath = mkOption {
      type = types.str;
      description = "Path to the mpd sticker database file";
    };
    mpdPassword = mkOption {
      type = types.str;
      description = "Password for MPD";
      default = "";
    };
  };

  config = mkIf cfg.enable {
    systemd.user = {
      paths = {
        mpd-ratings-dump = {
          Unit = {
            Description = "Triggers ratings dump when the mpd sticker database is modified";
          };

          Path = {
            PathModified = cfg.mpdStickerDBPath;
            TriggerLimitBurst = 0;
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        mpd-ratings-load = {
          Unit = {
            Description = "Triggers ratings load when the sync databases are updated";
          };

          Path = {
            PathChanged = cfg.ratingsDBDir;
            TriggerLimitBurst = 0;
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
      services = {
        mpd-ratings-dump = {
          Unit = {
            Description = "Dumps ratings from mpd to the sync database";
          };

          Service = {
            Environment = environmentVars;
            Type = "oneshot";
            ExecStart = "${pythonPath} ${scriptDir}/dump_ratings.py";
            WorkingDirectory = cfg.ratingsDBDir;
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        mpd-ratings-load = {
          Unit = {
            Description = "Load MPD ratings from every synced database";
          };

          Service = {
            Environment = environmentVars;
            Type = "oneshot";
            ExecStart = "${pythonPath} ${scriptDir}/load_ratings.py";
            WorkingDirectory = cfg.ratingsDBDir;
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
  };
}
