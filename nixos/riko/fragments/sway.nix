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

  services.displayManager = {
    defaultSession = "sway";
    sessionPackages = [ pkgs.sway ];
  };
}
