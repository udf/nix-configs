{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  CONFIG_PATH = "/var/lib/szuru/config.yaml";
  DATA_PATH = "/var/lib/szuru/data";
  SQL_PATH = "/var/lib/szuru/sql";
  SRC_DIR = "/var/lib/szuru/src";
  UI_PORT = 8008;
  UID = toString config.users.users.szuru.uid;
  GID = toString config.users.groups.szuru.gid;
  USER = "${UID}:${GID}";
  ipsetCfg = config.custom.ipset-block;
in
{
  imports = [ inputs.arion.nixosModules.arion ];
  users.extraUsers.szuru = {
    home = "/home/szuru";
    isSystemUser = true;
    group = "szuru";
    uid = 8008;
  };
  users.groups.szuru = {
    gid = 8008;
  };

  services.watcher-bot.plugins = [ "${../../_common/constants/watcher}/szuru_ip" ];
  systemd.services.watcher-bot = {
    wants = [ "${ipsetCfg.asnDBServiceName}.service" ];
    environment = {
      IPASN_DB = "${ipsetCfg.asnDBDir}/ipasn.dat.gz";
      ASNAMES_JSON = "${ipsetCfg.asnDBDir}/asnames.json";
    };
  };

  systemd.services.szuru =
    let
      genArionCmd = args: "arion --prebuilt-file \"$ARION_PREBUILT\" ${args} 1>&2";
    in
    {
      after = [
        "docker.service"
        "docker.socket"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      script = lib.mkForce (genArionCmd "up");
      serviceConfig = {
        TimeoutStartSec = 300;
        StandardError = "journal";
        StandardOutput = "journal";
        StandardInput = "null";
        EnvironmentFile = "-/run/szuru.env";
        ExecReload = pkgs.writeShellScript "szuru-reload.sh" ''
          cd "${SRC_DIR}"
          echo BUILD_INFO=$VERSION > /run/szuru.env
          export BUILD_INFO=$(${pkgs.git}/bin/git describe --always --dirty --long --tags)
          ${genArionCmd "up --build --force-recreate --wait"}
          kill -HUP $MAINPID
        '';
        ExecStop = pkgs.writeShellScript "szuru-stop.sh" (genArionCmd "down");
        Restart = "always";
        RestartSec = 5;
        UMask = "0000";
      };
    };

  systemd.services.szuru-rebuild = {
    description = "Rebuild szuru containers";
    after = [ "szuru.service" ];
    wants = [ "szuru.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "szuru-trigger-reload.sh" ''
        ${lib.getExe' pkgs.systemd "systemctl"} reload szuru.service || true
      '';
    };
  };

  # based on https://github.com/rr-/szurubooru/blob/master/docker-compose.yml
  virtualisation.arion.projects.szuru = {
    serviceName = "szuru";
    settings.services = {
      server = {
        out.service.build.args = {
          BUILD_INFO = "\${BUILD_INFO}";
          PUID = UID;
          PGID = GID;
        };
        service = {
          build.context = "${SRC_DIR}/server";
          restart = "unless-stopped";
          user = USER;
          depends_on = [ "sql" ];
          env_file = [ "/var/lib/szuru/.env" ];
          environment = {
            THREADS = 4;
            POSTGRES_HOST = "sql";
          };
          volumes = [
            "${DATA_PATH}:/data"
            "${CONFIG_PATH}:/opt/app/config.yaml"
          ];
        };
      };

      client = {
        out.service.build.args = {
          BUILD_INFO = "\${BUILD_INFO}";
        };
        service = {
          build.context = "${SRC_DIR}/client";
          restart = "unless-stopped";
          depends_on = [ "server" ];
          environment = {
            BACKEND_HOST = "server";
            BASE_URL = "/";
          };
          volumes = [
            "${DATA_PATH}:/data:ro"
          ];
          ports = [
            "127.0.0.1:8008:80"
          ];
        };
      };

      sql.service = {
        # MARK: pinned version
        image = "postgres:16-alpine";
        command = [
          "postgres"
          "-c"
          "jit=off"
        ];
        restart = "unless-stopped";
        env_file = [ "/var/lib/szuru/.env" ];
        volumes = [
          "${SQL_PATH}:/var/lib/postgresql/data"
        ];
        labels = {
          "diun.enable" = "false";
        };
      };
    };
  };

  services.nginxProxy.paths = {
    "booru" = {
      port = UI_PORT;
      useAuth = false;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Script-Name /szuru;
        proxy_connect_timeout 10s;
        proxy_send_timeout 10s;
        proxy_read_timeout 10s;
      '';
      extraServerConfig = ''
        client_max_body_size 25M;
      '';
    };
  };
}
