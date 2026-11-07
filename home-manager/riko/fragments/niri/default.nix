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
  };

  # TODO: generate dynamically
  custom.niri.configFiles = [
    ./config.d/input.kdl
    ./config.d/outputs.kdl
    ./config.d/layout.kdl
    ./config.d/binds-misc.kdl
    ./config.d/binds-navigation.kdl
    ./config.d/binds-programs.kdl
    ./config.d/binds-windows.kdl
    ./config.d/binds-workspaces.kdl
    ./config.d/binds-fn-mediakeys.kdl
    ./config.d/screenshots.kdl
    ./config.d/recent-windows.kdl
    ./config.d/startup-programs.kdl
    ./config.d/window-rules.kdl
    ./config.d/lid-switch.kdl
  ];

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
