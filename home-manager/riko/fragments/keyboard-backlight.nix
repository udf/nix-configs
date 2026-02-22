{ pkgs, lib, config, ... }:
let
  kbdBacklight = pkgs.writeShellScriptBin "kbd-backlight.sh" ''
    ARGS=("i")
    case "$1" in
      "up")
        ARGS=("s" "+1")
        ;;

      "down")
        ARGS=("s" "1-")
        ;;
    esac

    readarray -d ',' -t OUTPUT < <(${lib.getExe pkgs.brightnessctl} -m -d "asus::kbd_backlight" "''${ARGS[@]}")
    ${lib.getExe config.namedPackages.osd-notify} keyboard-brightness "" "''${OUTPUT[2]}:''${OUTPUT[4]%%[[:space:]]}"
  '';
in
{
  imports = [ ./swayosd.nix ];

  namedPackages.kbd-backlight = kbdBacklight;

  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "XF86KbdBrightnessUp" = "exec ${lib.getExe kbdBacklight} up";
        "XF86KbdBrightnessDown" = "exec ${lib.getExe kbdBacklight} down";
      };
    };
  };
}
