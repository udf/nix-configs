{ ... }:
{
  services.auto-cpufreq = {
    enable = true;
    settings.battery = {
      governor = "powersave";
      energy_performance_preference = "power";
      platform_profile = "quiet";
      turbo = "auto";
    };
    settings.charger = {
      governor = "performance";
      energy_performance_preference = "performance";
      platform_profile = "balanced";
      turbo = "always";
    };
  };
}
