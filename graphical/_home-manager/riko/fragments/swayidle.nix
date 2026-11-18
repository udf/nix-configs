{
  pkgs,
  config,
  lib,
  ...
}:
let
  niriCmd = lib.getExe' config.wayland.windowManager.niri.package "niri";
  dimScreenPkg = (pkgs.callPackage ../packages/dim-screen.nix { });
  kbdBacklightExe = lib.getExe config.namedPackages.kbd-backlight;
in
{
  system.services.acpid.handlers = {
    user-restart-swayidle = {
      event = "ac_adapter/*";
      action = "systemctl --user -M sam@ try-restart swayidle.service";
    };
  };

  custom.swayidle.commands.displayOn = ''
    ${niriCmd} msg action power-on-monitors
    ${kbdBacklightExe} --silent 1
  '';
  custom.swayidle.commands.displayOff = ''
    ${niriCmd} msg action power-off-monitors
    ${kbdBacklightExe} --silent 0
  '';
  custom.swayidle.commands.dimScreen =
    "${lib.getExe dimScreenPkg} --alpha 0.66 --duration 10";
}
