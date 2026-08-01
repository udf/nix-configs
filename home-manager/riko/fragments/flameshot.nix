{ ... }: {
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        saveAfterCopy = true;
        savePath = "/tmp/screenshots";
        savePathFixed = true;
      };
    };
  };

  system.systemd.tmpfiles.rules = [
    "d /tmp/screenshots 0700 sam users - -"
  ];

  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "Mod4+Shift+S" = "exec flameshot gui --last-region --clipboard";
      };
    };
  };
}
