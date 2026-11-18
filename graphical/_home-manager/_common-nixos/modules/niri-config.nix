{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.niri;
  includeLines = ''
    // Generated from `custom.niri.extraConfigFiles`
    ${lib.concatStringsSep "\n" (lib.map (f: "include \"${f}\"") cfg.extraConfigFiles)}
  '';
in
{
  options.custom.niri = {
    extraConfigFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "List of .kdl config file paths to generate includes for in `wayland.windowManager.niri.extraConfig`";
    };
  };

  config = lib.mkIf (cfg.extraConfigFiles != [ ]) {
    wayland.windowManager.niri = {
      extraConfig = includeLines;
    };
  };
}
