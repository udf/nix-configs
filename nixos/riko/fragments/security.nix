{
  config,
  pkgs,
  lib,
  ...
}:
let
  sudoFprintSuccessMessage = pkgs.writeShellScript "sudo-fprint-success-message" ''
    if [ -t 1 ]; then
      printf '%s\n' 'Success!' || true
    fi
    exit 0
  '';
in
{
  services.gnome.gnome-keyring.enable = true;

  security = {
    pam = {
      loginLimits = [
        {
          domain = "@wheel";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
      services.sudo = {
        fprintAuth = true;
        # Add success feedback to fingerprint auth without overriding the full PAM file.
        # Built-in auth rules currently use 100-step auto-ordering, with `fprintd`
        # landing at order 11400. Keep the follow-up rules in explicit slots
        # immediately after it so the feedback path cannot recurse on or depend on
        # the generated `fprintd` rule definition.
        rules.auth = {
          fprintd.control = lib.mkForce "[success=ok default=2]";
          fprintSuccessFeedback = {
            order = 11410;
            control = "[success=ok default=ignore]";
            modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
            args = [
              "stdout"
              "${sudoFprintSuccessMessage}"
            ];
          };
          fprintSuccessComplete = {
            order = 11420;
            control = "[success=done default=die]";
            modulePath = "${config.security.pam.package}/lib/security/pam_permit.so";
          };
        };
      };
    };
    polkit.enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
