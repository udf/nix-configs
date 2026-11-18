{
  config,
  pkgs,
  ...
}:
{
  environment.etc."pam-sudo-success-message.sh" = {
    mode = "0755";
    text = ''
      #!${pkgs.runtimeShell}
      if [ "$PAM_TYPE" = "open_session" ] && [ -n "$PAM_TTY" ] && [ -w "$PAM_TTY" ]; then
        printf '[pam] authentication successful!\n' > "$PAM_TTY"
      fi
    '';
  };

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
        rules.session = {
          successTty = {
            order = 12300;
            control = "optional";
            modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
            args = [
              "seteuid"
              "/etc/pam-sudo-success-message.sh"
            ];
          };
        };
      };
    };
  };
}
