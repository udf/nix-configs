{ ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_SCALING_MIN_FREQ_ON_AC = 423206;
      CPU_SCALING_MIN_FREQ_ON_BAT = 423206;
      CPU_SCALING_MIN_FREQ_ON_SAV = 423206;
    };
  };
}
