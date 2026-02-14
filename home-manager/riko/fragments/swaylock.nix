{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      show-failed-attempts = true;
      effect-scale = "0.5";
      effect-blur = "14x5";
      effect-vignette = "0.5:0.5";
      clock = true;
      indicator = true;
      indicator-radius = "75";
      text-color = "ffffff";
      font = "Hack";
      font-size = "24";
    };
  };
}
