{ pkgs, lib, ... }:
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
    osd-notify.sh keyboard-brightness "" "''${OUTPUT[2]}:''${OUTPUT[4]%%[[:space:]]}"
  '';
in
{
  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "XF86KbdBrightnessUp" = "exec ${lib.getExe kbdBacklight} up";
        "XF86KbdBrightnessDown" = "exec ${lib.getExe kbdBacklight} down";
      };
    };
  };
}
