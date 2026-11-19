{
  osConfig,
  ...
}:
{
  catppuccin = {
    enable = true;
    autoEnable = true;

    cursors.enable = false;
    vscodium.profiles.default.enable = false;
    kvantum.apply = true;
    gtk.icon.enable = true;

    inherit (osConfig.custom.catppuccin) flavor accent sources;
  };
}
