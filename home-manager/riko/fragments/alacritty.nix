{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics;
  };
}
