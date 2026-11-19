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

    bindings =
      let
        cuberoot2 = 1.2599210498948732;
      in
      {
        "WHEEL_UP" = "seek 10";
        "WHEEL_DOWN" = "seek -10";
        "WHEEL_LEFT" = "add volume -2";
        "WHEEL_RIGHT" = "add volume 2";

        "ctrl+1" = "set speed 1.0";
        "ctrl+2" = "set speed 2.0";
        "ctrl+3" = "set speed 3.0";
        "ctrl+4" = "set speed 4.0";

        "]" = "multiply speed ${toString cuberoot2}";
        "[" = "multiply speed ${toString (1.0 / cuberoot2)}";
      };
  };
}
