{ pkgs, inputs, ... }: {
  custom.niri.extraConfigFiles = [
    # plugins/regent_urgent.py
    (pkgs.writeTextFile {
      name = "focus-recent-urgent.kdl";
      text = ''
        binds {
          Mod+Z { spawn "systemctl" "--user" "kill" "-s" "SIGUSR1" "snirid.service"; }
        }
      '';
    })
  ];

  home.packages = [
    (pkgs.python3Packages.toPythonApplication inputs.snirid.lib.snirid)
  ];

  services.snirid = {
    enable = true;
    pluginDirs = [ ./plugins ];
  };
}
