{ ... }:
{
  services.scx-loader = {
    enable = true;
    config = {
      default_sched = "scx_lavd";
      default_mode = "Auto";
      scheds.scx_lavd = {
        auto_mode = [ "--autopower" ];
      };
    };
  };
}
