{
  config,
  lib,
  ...
}:
let
  port = 3256;
  secondsPerDay = 60 * 60 * 24;
  hostName = "soon.withsam.org";
  pgDatabase = "vikunja";
in
{
  services.vikunja = {
    enable = true;
    settings = {
      service = {
        enableregistration = false;
        jwtttl = secondsPerDay * 30;
        jwtttllong = secondsPerDay * 90;
        maxitemsperpage = 100;
        interface = lib.mkForce "127.0.0.1:${toString port}";
      };
    };
    database = {
      type = "postgres";
      user = pgDatabase;
      database = pgDatabase;
      host = "/run/postgresql";
    };
    port = port;
    frontendScheme = "http";
    frontendHostname = hostName;
  };

  systemd.services.vikunja = {
    after = [ "postgresql.target" ];
    requires = [ "postgresql.target" ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ pgDatabase ];
    ensureUsers = [
      {
        name = pgDatabase;
        ensureDBOwnership = true;
      }
    ];
  };

  security.acme.certs = {
    "${config.services.nginxProxy.serverHost}".extraDomainNames = [ hostName ];
  };

  services.nginxProxy.paths = {
    "soon" = {
      port = port;
      serverHost = hostName;
      useAuth = false;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        client_max_body_size 5000M;
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };
}
