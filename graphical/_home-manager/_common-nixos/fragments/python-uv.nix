{ pkgs, ... }:
let
  defaultVersion = "3.14";
  uvPkg = pkgs.symlinkJoin {
    name = "uv-wrapped";
    paths = [ pkgs.uv ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/uv \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.gcc ]}
    '';
    meta = pkgs.uv.meta;
  };
in
{
  home.packages = [
    pkgs.pypy3
    (pkgs.python3.withPackages (
      ps: with ps; [
        # TODO: add more packages
        numpy
        matplotlib
      ]
    ))
  ];

  programs.uv = {
    enable = true;
    package = uvPkg;
    python = {
      prune = true;
      default = [ defaultVersion ];
      versions = [
        defaultVersion
      ];
    };
    # Note: upgrade with uv tool upgrade --reinstall --all
    tool = {
      prune = true;
      packages = [
        # TODO: add more tools
        "yt-dlp[default] @ https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz"
      ];
    };
    settings = {
    };
  };
}
