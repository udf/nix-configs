{
  lib,
  pkgs,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "dim-screen";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "marcelohdez";
    repo = "dim";
    rev = "84034e1c7de8ff7679e633c92deabe4d00201bc8";
    sha256 = "sha256-BwUBCRmNI3WfX7aTX7W8XnDX6u9NDBWz9CMaAyvbDY4=";
  };

  cargoHash = "sha256-IS86bGdf5jykZg5FI76ChD5wzoNJ6lLct2I7qylLs58=";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [
    pkgs.libxkbcommon
    pkgs.wayland
  ];

  doCheck = false;

  meta = with lib; {
    description = "Native Wayland screen dimming tool";
    homepage = "https://github.com/marcelohdez/dim";
    license = licenses.gpl3;
    mainProgram = "dim";
    maintainers = [ ];
  };
}
