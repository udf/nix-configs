{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.syncplay = {
    enable = true;
    useACMEHost = config.services.nginxProxy.serverHost;
  };
  systemd.services.syncplay.environment = {
    SYNCPLAY_PASSWORD = "hentai";
  };
  networking.firewall.allowedTCPPorts = [ config.services.syncplay.port ];
}
