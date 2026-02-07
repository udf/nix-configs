{
  lib,
  buildPythonPackage,
  fetchPypi,
  deemix,
  requests,
  click,
  plexapi,
  tqdm,
  mutagen,
  unidecode,
}:

buildPythonPackage rec {
  pname = "deemon";
  version = "2.22";
  format = "setuptools";

  patches = [ ./move-appdata-init-to-cli-main.patch ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CkX0gYzyJyv80F3LoLGCDMy+db9mDvFbZqqdD/HcOxc=";
  };

  propagatedBuildInputs = [
    (deemix.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ./deemix-allow-more-path-chars.patch ];
    }))
    requests
    click
    plexapi
    tqdm
    mutagen
    unidecode
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "deemon" ];

  meta = {
    description = "Monitor new releases by a specified list of artists and auto download using the deemix library";
    mainProgram = "deemon";
    homepage = "https://github.com/digitalec/deemon";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
