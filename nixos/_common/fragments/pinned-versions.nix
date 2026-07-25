{
  pkgs,
  ...
}:
{
  custom.pinnedVersions = {
    containers = {
      diun = "crazymax/diun:4.31";
      pihole = "pihole/pihole:2026.04.1";
      nebula-sync = "ghcr.io/lovelaze/nebula-sync:v0.11.2";
      nextcloud-aio-imaginary = "nextcloud/aio-imaginary:20260527_140826";
      suwayomi-tachidesk = "ghcr.io/suwayomi/tachidesk:v2.3.2243";
      szuru-postgres = "postgres:16-alpine";
      frigate = "ghcr.io/blakeblackshear/frigate:0.17.2";
    };
    programs = {
      nicotine-plus = "3.3.10";
      flexget-webui = "2.0.29";
    };
    packages = {
      nextcloud = pkgs.nextcloud33;
    };
  };
}
