{
  config,
  pkgs,
  ...
}:
{
  environment.etc."sudo-auth-success-motd".text = ''
    Success!
  '';

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
        rules.session = {
          successMotd = {
            order = 12300;
            control = "optional";
            modulePath = "${config.security.pam.package}/lib/security/pam_motd.so";
            args = [
              "motd=/etc/sudo-auth-success-motd"
              "noupdate"
            ];
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
