{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.niri;
  includeLines = ''
    // Generated from `custom.niri.configFiles`
    ${lib.concatStringsSep "\n" (lib.map (f: "include \"${f}\"") cfg.configFiles)}
  '';
in
{
  options.custom.niri = {
    configFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "List of .kdl config files to include in niri config via absolute paths";
    };
  };

  config = lib.mkIf (cfg.configFiles != [ ]) {
    wayland.windowManager.niri = {
      extraConfig = includeLines;
    };
  };
}
