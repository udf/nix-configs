{ pkgs, ... }: {
  i18n = {
    defaultLocale = "en_ZA.UTF-8";
    extraLocales = [ "en_GB.UTF-8/UTF-8" ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-configtool
        ];
        settings.globalOptions = {
          "Behavior/DisabledAddons" = {
            "0" = "clipboard";
          };

          "Hotkey/PrevPage" = {
            "0" = "Page_Up";
            "1" = "minus";
          };
          "Hotkey/NextPage" = {
            "0" = "Page_Down";
            "1" = "equal";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Up";
            "1" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Down";
            "1" = "Tab";
          };
        };
      };
    };
  };
}
