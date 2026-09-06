{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  niriPkg = inputs.niri-virtual-outputs.packages.${system}.default;
in
{
  wayland.windowManager.niri = {
    enable = true;
    package = niriPkg;
  };

  home.packages = with pkgs; [
    fuzzel
    waybar
    wl-mirror
  ];

  system.services.displayManager.sessionPackages = [ niriPkg ];
}
