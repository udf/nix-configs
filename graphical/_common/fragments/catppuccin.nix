{
  config,
  ...
}:
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    inherit (config.custom.catppuccin) flavor accent sources;
  };
}
