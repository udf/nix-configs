{
  unstablePkgs,
  lib,
  fetchFromGitHub,
  wrapGAppsHook3,
  gdk-pixbuf,
  gettext,
  gobject-introspection,
  gtk3,
  glib,
  python3Packages,
  config,
  libadwaita,
}:
let
  pname = "nicotine-plus";
  version = config.custom.pinnedVersions.programs.nicotine-plus;
in
assert unstablePkgs.nicotine-plus.version == version;
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;
  src = fetchFromGitHub {
    owner = "nicotine-plus";
    repo = "nicotine-plus";
    tag = version;
    hash = "sha256-/+sk5Ur/nfgIFbnCgXtgjNevt3NMbVcgoQni/oD5owo=";
  };

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
    gobject-introspection
    glib
    gdk-pixbuf
    gtk3
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  build-system = [
    python3Packages.setuptools
  ];

  postInstall = ''
    ln -s $out/bin/nicotine $out/bin/nicotine-plus
  '';

  dontWrapGAppsHook = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;
  meta = {
    description = "Graphical client for the SoulSeek peer-to-peer system";
    mainProgram = "nicotine";
    longDescription = ''
      Nicotine+ aims to be a pleasant, free and open source (FOSS) alternative
      to the official Soulseek client, providing additional functionality while
      keeping current with the Soulseek protocol.
    '';
    homepage = "https://www.nicotine-plus.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      klntsky
      amadaluzia
    ];
  };
}
