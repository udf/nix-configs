{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "mpd-ratings-sync";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "udf";
    repo = "mpd-ratings-sync";
    rev = "6fd044c884bb7a60495427cae698f4a220e7ed76";
    sha256 = "sha256-eMuDMt8FbEj2mnGc0TZ4SEbDNgIbrruRXSiTe7GZVK0=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = [ (pkgs.python3.withPackages (ps: [ ps.mpd2 ])) ];

  installPhase = ''
    install -d $out/share/mpd-ratings-sync
    cp *.py $out/share/mpd-ratings-sync/
    for f in dump_ratings.py load_ratings.py; do
      makeWrapper ${pkgs.python3.withPackages (ps: [ ps.mpd2 ])}/bin/python3 "$out/bin/$f" \
        --add-flags "$out/share/mpd-ratings-sync/$f"
      chmod +x "$out/bin/$f"
    done
  '';

  meta = with pkgs.lib; {
    description = "MPD ratings sync utility";
    homepage = "https://github.com/udf/mpd-ratings-sync";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
  };
}
