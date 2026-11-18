{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  niriPkg = inputs.niri-main.packages.${system}.default;
in
{
  wayland.windowManager.niri = {
    package = niriPkg;
  };
}
