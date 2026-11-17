{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      font-awesome
      source-han-sans
      source-han-serif
      nerd-fonts.hack
      roboto
    ];
    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK"
        "Source Han Serif"
      ];
      sansSerif = [
        "Roboto"
        "Noto Sans"
        "Noto Sans CJK"
        "Source Han Sans"
      ];
      monospace = [
        "Hack Nerd Font"
      ];
    };
  };
}
