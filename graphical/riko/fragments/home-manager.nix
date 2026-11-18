{ config, lib, ... }:
let
  forwardedSystemNamespaces = [
    "systemd"
    "services"
    "environment"
    "security"
  ];

  # TODO: rename to osConfigBridge and assert for unknown namespaces
  forwardedSystemConfig = builtins.listToAttrs (
    map (namespace: {
      name = namespace;
      value = lib.attrByPath [ "home-manager" "users" "sam" "system" namespace ] { } config;
    }) forwardedSystemNamespaces
  );
in
{
  home-manager.users.sam = import ../../_home-manager/riko/home.nix;
}
// forwardedSystemConfig
