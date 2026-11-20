{ pkgs, lib, ... }:
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
  pythonPkg = (
    pkgs.python3.withPackages (
      ps: with ps; [
        # TODO: add more packages
        numpy
        matplotlib
      ]
    )
  );
in
{
  home.packages = [
    pkgs.pypy3
    pythonPkg
  ];

  home.sessionVariables = {
    NIX_PYTHON_PATH = "${lib.getExe pythonPkg}";
  };

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
