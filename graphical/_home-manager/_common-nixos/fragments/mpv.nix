{ pkgs, ... }:
let
  # https://github.com/po5/thumbfast/pull/173
  thumbfastPkg = pkgs.mpvScripts.thumbfast.overrideAttrs (_old: {
    # MARK: pinned version
    src = pkgs.fetchFromGitHub {
      owner = "N-R-K";
      repo = "thumbfast";
      rev = "edbc294010bb0d7b3fc5f929c70c6f9b44132654";
      hash = "sha256-AQ28Nm+6SEELbFOa0PpCWWapcwwJ3G8ttB99QlGgeCs=";
    };
  });
in
{
  programs.mpv = {
    enable = true;

    scripts = [
      pkgs.mpvScripts.mpris
      thumbfastPkg
    ];

    scriptOpts = {
      thumbfast = {
        hwdec = "yes";
      };
    };

    config = {
      "term-playing-msg" = "'[\${playlist-pos-1}/\${playlist-count}] \${media-title}'";

      "vo" = "gpu-next";
      "hwdec" = "auto";
      "video-sync" = "display-resample";
      "interpolation" = "yes";
      "tscale" = "oversample";
      "af" = "scaletempo2=max-speed=8";
      "replaygain" = "track";

      "screenshot-format" = "webp";
      "screenshot-webp-lossless" = "yes";
      "screenshot-webp-compression" = "4";
      "screenshot-template" = "mpv-shot-%tY-%tm-%td-%tH:%tM:%tS-%n";
      "screenshot-directory" = "~/mpv_screenshots";

      "ytdl-format" = "bestvideo[height<=?1440]+bestaudio/best";

      "cache" = "yes";
      "demuxer-max-bytes" = "256M";

      "alang" = "jp,jpn,en,eng";
      "slang" = "jp,jpn,en,eng";

      "volume" = "90";
    };
  };
}
