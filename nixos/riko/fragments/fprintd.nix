{ pkgs, ... }:
{
  services.fprintd.enable = true;
  services.fprintd.tod = {
    enable = true;
    driver = pkgs.libfprint-2-tod1-elan;
  };
}
