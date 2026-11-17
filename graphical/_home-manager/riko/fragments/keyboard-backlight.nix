{
  pkgs,
  lib,
  config,
  ...
}:
let
  kbdBacklight = pkgs.writeShellScriptBin "kbd-backlight.sh" ''
    SILENT=0
    if [ "$1" = "--silent" ]; then
      SILENT=1
      shift
    fi

    ARGS=("i")
    case "$1" in
      "up")
        ARGS=("s" "+1")
        ;;

      "down")
        ARGS=("s" "1-")
        ;;

      *)
        ARGS=("s" "$1")
        ;;
    esac

    readarray -d ',' -t OUTPUT < <(${lib.getExe pkgs.brightnessctl} -m -d "asus::kbd_backlight" "''${ARGS[@]}")
    if [ "$SILENT" -ne 1 ]; then
      max_brightness="''${OUTPUT[4]%%[[:space:]]}"
      current_brightness="''${OUTPUT[2]}"
      icon=keyboard-brightness-medium-symbolic
      case "$current_brightness" in
        "0")
          icon=keyboard-brightness-off-symbolic
          ;;
        "$max_brightness")
          icon=keyboard-brightness-high-symbolic
          ;;
      esac
      ${lib.getExe config.namedPackages.osd-notify} "$icon" "" "$current_brightness:$max_brightness"
    fi
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
