{ config, pkgs, ... }:
let
  python-pkg = pkgs.python313.withPackages (
    ps: with ps; [
      aiohttp
      aiohttp-cors
    ]
  );
  hostName = "l.withsam.org";
in
{
  systemd.services.linkwithsam = {
    description = "Simple link shortener service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ python-pkg ];

    serviceConfig = {
      User = "linkwithsam";
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "/home/linkwithsam/linkwithsam";
      ExecStart = "${python-pkg}/bin/python main.py";
    };
  };

  services.nginxProxy.paths = {
    "linkwithsam" = {
      serverHost = hostName;
      useAuth = false;
      port = 9037;
      extraConfig = ''
        proxy_set_header X-Forwarded-For $remote_addr;
      '';
    };
  };

  security.acme.certs = {
    "${config.services.nginxProxy.serverHost}".extraDomainNames = [ hostName ];
  };

  users.extraUsers.linkwithsam = {
    description = "linkwithsam user";
    home = "/home/linkwithsam";
    isSystemUser = true;
    group = "linkwithsam";
  };
  users.groups.linkwithsam = { };
}
