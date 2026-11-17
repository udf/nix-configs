{
  pkgs,
  ...
}:
{
  programs.sway = {
    enable = true;
    package = null;
    wrapperFeatures.gtk = true;
  };

  services.displayManager.sessionPackages = [ pkgs.sway ];
}
