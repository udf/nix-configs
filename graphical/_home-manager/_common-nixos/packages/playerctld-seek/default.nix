{
  lib,
  stdenv,
  pkg-config,
  systemd,
}:

stdenv.mkDerivation {
  pname = "playerctld-seek";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./playerctld-seek.cpp;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];

  buildPhase = ''
    $CXX -std=c++20 -O2 -s playerctld-seek.cpp -o playerctld-seek $(pkg-config --cflags --libs libsystemd)
  '';

  installPhase = ''
    install -Dm755 playerctld-seek $out/bin/playerctld-seek
  '';

  meta = {
    description = "Minimal sd-bus client to seek the active player through playerctld";
    mainProgram = "playerctld-seek";
    platforms = lib.platforms.linux;
  };
}
