{ config, pkgs, ... }:
{
  services.mpdris2.package = pkgs.mpdris2.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./more-sane-interval.patch ];
    version = "0.10.0";
    src = pkgs.fetchFromGitHub {
      owner = "eonpatapon";
      repo = "mpDris2";
      rev = "55d571f1d1e719b673f2bba7662628207e0ec78d";
      hash = "sha256-Caw7WZIpTgwaXJ/voKI6rsDigvyrHK3t/QM4B3WJlE0=";
    };
  });
}
