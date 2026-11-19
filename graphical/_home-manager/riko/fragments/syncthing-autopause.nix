{ lib, pkgs, ... }:
let
  nonCriticalFolderIds = [
    # Projects - Other
    "dy5hy-9y2dd"
    # Transcoded Music (All Playlists)
    "dp4wu-7x2ph"
  ];
in
{
  systemd.user.services.syncthing-autopause = {
    Unit = {
      Description = "Screen locker";
      Requires = [ "syncthing.service" ];
    };

    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "syncthing-autopause.sh" ''
        ${pkgs.coreutils}/bin/sleep 3
        if systemd-ac-power; then
          PAUSE="false";
          STATUS="Unpausing"
        else
          PAUSE="true";
          STATUS="Pausing"
        fi

        for folderId in ${lib.escapeShellArgs nonCriticalFolderIds}; do
          echo "$STATUS: $folderId"
          ${lib.getExe pkgs.curl} -sS -X PATCH \
            -H "X-API-Key: 7UHKmQAY3enFvSkSDsyNRjW2dTEZhnjw" \
            -H "Content-Type: application/json" \
            -d "{\"paused\": $PAUSE}" \
            "http://localhost:8384/rest/config/folders/$folderId"
        done
      '';
    };
  };

  systemConfig.services.acpid.handlers = {
    user-restart-syncthing-autopause = {
      event = "ac_adapter/*";
      action = ''
        systemctl --user -M sam@ start syncthing-autopause.service
      '';
    };
  };
}
