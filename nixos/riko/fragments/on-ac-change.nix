{ ... }:
{
  systemd.user.services.on-ac-change = {
    description = "Runs user related tasks on AC power change";
    unitConfig.ConditionUser = "sam";
    script = ''
      systemctl try-restart --user swayidle.service
    '';
    serviceConfig.Type = "oneshot";
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_TYPE}=="Mains", \
    TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="on-ac-change.service"
  '';
}
