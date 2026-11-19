{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.swayidle;

  toScript =
    name: lines: lib.getExe (pkgs.writeShellScriptBin "swayidle-${name}" ("set -e\n" + lines));

  defaultLockCommand = "${pkgs.systemd}/bin/systemctl start --no-block --user screen-locker";
  defaultIsLockActive = "${pkgs.systemd}/bin/systemctl --user is-active screen-locker";
in
{
  options.custom.swayidle = {
    commands = {
      lock = lib.mkOption {
        type = lib.types.str;
        default = defaultLockCommand;
        description = "Shell command to lock the screen";
      };
      isLockActive = lib.mkOption {
        type = lib.types.str;
        default = defaultIsLockActive;
        description = "Shell command to check if the screen is locked";
      };
      displayOn = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines to turn displays on";
      };
      displayOff = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines to turn displays off";
      };
      dimScreen = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Shell command to dim the screen";
      };
    };

    resumeCommands = {
      lockedIdle = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines to run when waking from the locked idle timeout";
      };
      postLockIdle = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines to run when waking from the post-lock idle timeout";
      };
    };

    timeouts = {
      lockedIdle = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the locked idle timeout (20s)";
      };
      notifyIdle = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the notify idle timeout (105s)";
      };
      dimScreen = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the dim screen timeout (110s)";
      };
      lock = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the lock timeout (120s)";
      };
      postLockIdle = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the post-lock idle timeout (125s)";
      };
      postLockSuspend = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the post-lock suspend timeout (300s)";
      };
    };

    events = {
      beforeSleep = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the before-sleep event";
      };
      afterResume = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the after-resume event";
      };
      lock = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell command lines for the lock event";
      };
    };
  };

  config = {
    assertions = [
      (lib.mkIf (cfg.commands.lock == defaultLockCommand) {
        assertion = config.systemd.user.services ? "screen-locker";
        message = "a screen-locker.service is required for the default lock command";
      })
      {
        assertion =
          !(cfg.commands.lock != defaultLockCommand && cfg.commands.isLockActive == defaultIsLockActive);
        message = "Overriding the default lock command requires the isLockActive command to be changed as well";
      }
    ];

    custom.swayidle.timeouts.lockedIdle = lib.mkDefault (
      cfg.commands.isLockActive + "\n" + cfg.commands.displayOff
    );
    custom.swayidle.timeouts.dimScreen = lib.mkDefault cfg.commands.dimScreen;
    custom.swayidle.timeouts.lock = lib.mkDefault cfg.commands.lock;
    custom.swayidle.timeouts.postLockIdle = lib.mkDefault cfg.commands.displayOff;
    custom.swayidle.timeouts.notifyIdle = lib.mkDefault "${pkgs.libnotify}/bin/notify-send 'Session will be locked soon' -t 5000";
    custom.swayidle.timeouts.postLockSuspend = lib.mkDefault "${lib.getExe' pkgs.systemd "systemd-ac-power"} || ${pkgs.systemd}/bin/systemctl suspend";
    custom.swayidle.events.beforeSleep = lib.mkDefault cfg.commands.lock;
    custom.swayidle.events.afterResume = lib.mkDefault cfg.commands.displayOn;
    custom.swayidle.events.lock = lib.mkDefault cfg.commands.lock;
    custom.swayidle.resumeCommands.lockedIdle = lib.mkDefault cfg.commands.displayOn;
    custom.swayidle.resumeCommands.postLockIdle = lib.mkDefault cfg.commands.displayOn;

    services.swayidle = {
      enable = true;
      extraArgs = [ ];
      timeouts = [
        {
          timeout = 20;
          command = toScript "locked-idle" cfg.timeouts.lockedIdle;
          resumeCommand = toScript "locked-idle-resume" cfg.resumeCommands.lockedIdle;
        }
        {
          timeout = 105;
          command = toScript "notify-idle" cfg.timeouts.notifyIdle;
        }
        {
          timeout = 110;
          command = toScript "dim-screen" cfg.timeouts.dimScreen;
        }
        {
          timeout = 120;
          command = toScript "lock" cfg.timeouts.lock;
        }
        {
          timeout = 125;
          command = toScript "post-lock-idle" cfg.timeouts.postLockIdle;
          resumeCommand = toScript "post-lock-idle-resume" cfg.resumeCommands.postLockIdle;
        }
        {
          timeout = 300;
          command = toScript "post-lock-suspend" cfg.timeouts.postLockSuspend;
        }
      ];
      events = {
        "before-sleep" = toScript "before-sleep" cfg.events.beforeSleep;
        "after-resume" = toScript "after-resume" cfg.events.afterResume;
        "lock" = toScript "lock-event" cfg.events.lock;
      };
    };
  };
}
