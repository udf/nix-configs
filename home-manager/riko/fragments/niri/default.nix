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
  imports = [ ./config.d.nix ];

  wayland.windowManager.niri = {
    enable = true;
    package = niriPkg;
    extraConfig = lib.mkAfter ''
      include "${scratchpadConfig}"
    '';
  };

  home.packages = with pkgs; [
    fuzzel
    waybar
    wl-mirror
    wlr-randr
  ];

  system.services.displayManager = {
    defaultSession = "niri";
    sessionPackages = [ niriPkg ];
  };
}
