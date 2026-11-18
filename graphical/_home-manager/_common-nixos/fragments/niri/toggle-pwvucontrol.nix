{ pkgs, lib, ... }:
let
  toggle-pwvucontrol = pkgs.writeShellApplication {
    name = "toggle-pwvucontrol";
    runtimeInputs = with pkgs; [
      procps
      pwvucontrol
    ];
    text = ''
      if pgrep -fx pwvucontrol > /dev/null; then
        pkill -fx pwvucontrol
      else
        pwvucontrol &
      fi
    '';
  };
in
{
  home.packages = [
    toggle-pwvucontrol
    pkgs.pwvucontrol
  ];

  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-toggle-pwvucontrol.kdl";
      text = ''
        binds {
          Mod+Ctrl+a repeat=false { spawn "${lib.getExe toggle-pwvucontrol}"; }
        }
        window-rule {
          match app-id=r#"com.saivert.pwvucontrol$"#
          open-floating true
        }
      '';
    })
  ];
}
