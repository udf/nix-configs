{
  config,
  lib,
  pkgs,
  ...
}:
let
  # not to self: find icon names with icon-library
  osdNotify = pkgs.writeShellScriptBin "osd-notify.sh" ''
    if [ "$#" -lt 2 ]; then
      echo "Usage: $0 icon message [progress]"
      exit 1
    fi

    ARGS=()

    if [ -n "$1" ]; then
      ARGS+=("--custom-icon" "$1")
    fi

    TEXT_ARG="--custom-message"
    if [ -n "$3" ]; then
      if [[ $3 == *:* ]]; then
        ARGS+=("--custom-segmented-progress" "$3")
      else
        ARGS+=("--custom-progress" "$3")
      fi
      TEXT_ARG="--custom-progress-text"
    fi

    if [ -n "$2" ]; then
      ARGS+=("$TEXT_ARG" "$2")
    fi

    ${lib.getExe' config.services.swayosd.package "swayosd-client"} "''${ARGS[@]}"
  '';
in
{
  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  namedPackages.osd-notify = osdNotify;
}
