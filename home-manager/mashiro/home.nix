{ config, pkgs, ... }:

{
  imports = [
    (import ../_autoload.nix ./.)
  ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";

  home.stateVersion = "25.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fnm
    mpd
    mpc
    edir
    brotab
    gh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sam/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    NODE_OPTIONS = "--max_old_space_size=4096";
    TURBO_CONCURRENCY = "16";
    TURBO_DAEMON = "false";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
