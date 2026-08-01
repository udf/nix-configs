{ config, lib, ... }:
let
  forwardedSystemNamespaces = [
    "systemd"
    "services"
    "environment"
  ];

  forwardedSystemConfig = builtins.listToAttrs (
    map (namespace: {
      name = namespace;
      value = lib.attrByPath [ "home-manager" "users" "sam" "system" namespace ] { } config;
    }) forwardedSystemNamespaces
  );
in
{
  home-manager.users.sam = import ../../../home-manager/riko/home.nix;
}
// forwardedSystemConfig
