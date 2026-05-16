{ config, pkgs, ... }:
{
  services.mpdris2.package = pkgs.mpdris2.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./more-sane-interval.patch ];
    version = "0.9.1-rc";
    src = pkgs.fetchFromGitHub {
      owner = "eonpatapon";
      repo = "mpDris2";
      rev = "d73f32c2b74528e94032331cd6cecb0b7e7bcada";
      hash = "sha256-J0OApalIqYCGiaxuE/10K6n2GyP6WoZHF7NcRG3FXnA=";
    };
  });
}
