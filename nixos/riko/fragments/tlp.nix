{ ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";

      CPU_SCALING_MIN_FREQ_ON_AC = 423206;
      CPU_SCALING_MIN_FREQ_ON_BAT = 423206;
      CPU_SCALING_MIN_FREQ_ON_SAV = 423206;

      START_CHARGE_THRESH_BAT0 = 95;
      START_CHARGE_THRESH_BAT1 = 95;
      STOP_CHARGE_THRESH_BAT0 = 100;
      STOP_CHARGE_THRESH_BAT1 = 100;
    };
  };
}
