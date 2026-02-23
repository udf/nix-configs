{ pkgs, ... }:
{
  systemd.user.services.on-ac-change = {
    description = "Runs user related tasks on AC power change";
    unitConfig.ConditionUser = "sam";
    script = ''
      systemctl try-restart --user swayidle.service
      ${pkgs.coreutils}/bin/sleep 1
    '';
    serviceConfig.Type = "oneshot";
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="[01]", \
    TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="on-ac-change.service"
  '';
}
