{ config, pkgs, ... }:
{
  services.mpdris2.package = pkgs.mpdris2.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./more-sane-interval.patch ];
  });
}
