{ lib, pkgs, ... }:
let
  listFilesWithExt =
    ((import ../../../helpers/list-files.nix) { inherit lib pkgs; }).listFilesWithExt;
  pythonBin = lib.getExe (
    with pkgs;
    python3.withPackages (ps: [
      (python3Packages.buildPythonPackage {
        pname = "mpd-client-helper";
        version = "0.1";
        src = ./.;
        format = "other";
        propagatedBuildInputs = with python3Packages; [ mpd2 ];
        installPhase = ''
          mkdir -p "$out/${python3.sitePackages}"
          cp "${./_mpd.py}" "$out/${python3.sitePackages}/_mpd.py"
        '';
      })
    ])
  );
in
{
  home.file = lib.listToAttrs (
    map
      (
        file:
        (
          (lib.nameValuePair "scripts/${builtins.toString file}" {
            text = ''
              #!${pythonBin}
              ${builtins.readFile (./. + "/${file}")}
            '';
            executable = true;
          })
        )
      )
      (
        builtins.filter (file: !lib.hasPrefix "_" file) (listFilesWithExt {
          dir = ./.;
          relative = true;
          ext = ".py";
        })
      )
  );
}
