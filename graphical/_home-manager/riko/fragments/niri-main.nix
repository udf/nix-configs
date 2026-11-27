{
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  niriPkg = inputs.niri-main.packages.${system}.default.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./niri-write-to-socket.patch ];
  });
in
{
  wayland.windowManager.niri = {
    package = niriPkg;
  };
}
