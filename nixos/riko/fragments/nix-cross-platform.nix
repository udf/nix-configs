{ config, ... }:
{
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
}
