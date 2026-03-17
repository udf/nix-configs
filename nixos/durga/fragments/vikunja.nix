{
  config,
  lib,
  pkgs,
  ...
}:
let
  port = 3256;
  secondsPerDay = 60 * 60 * 24;
  hostName = "soon.withsam.org";
  pgDatabase = "vikunja";

  # Patch frontend with nerd fonts
  srcPkg = pkgs.vikunja;
  patchedFrontend = srcPkg.frontend.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      pkgs.nerd-font-patcher
    ];

    patchPhase = (oldAttrs.patchPhase or "") + ''
      font=('src/assets/fonts/OpenSans[wght]'*.woff2)
      tmpdir=$(mktemp -d)
      nerd-font-patcher -c -out "$tmpdir" "$font"
      patched=$(find "$tmpdir" -name '*.woff2' -print -quit)
      cp "$patched" "$font"

      substituteInPlace src/styles/common-imports.scss \
        --replace-fail \
        "$vikunja-font: 'Quicksand', sans-serif;" \
        "$vikunja-font: 'Quicksand', 'Open Sans', sans-serif;"
    '';
  });
  patchedPkg = srcPkg.overrideAttrs (oldAttrs: {
    frontend = patchedFrontend;
    prePatch = ''
      cp -r ${patchedFrontend} frontend/dist
    '';
  });
in
{
  services.vikunja = {
    enable = true;
    package = patchedPkg;
    settings = {
      service = {
        enableregistration = false;
        jwtttl = secondsPerDay * 30;
        jwtttllong = secondsPerDay * 90;
        maxitemsperpage = 100;
        interface = lib.mkForce "127.0.0.1:${toString port}";
      };
      backgrounds.providers.unsplash = {
        enabled = true;
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
    serviceConfig.EnvironmentFile = "/var/lib/private/vikunja/vikunja.env";
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
