{ config, lib, ... }:
{
  # enabled for home-manager integrations (e.g. direnv)
  # so disable most defaults since we have the global zshrc
  programs.zsh = {
    enable = true;
    completionInit = "";
    setOptions = lib.mkForce [ ];
    history = {
      # no way to disable these :/
      size = 10000000;
      path = "${config.programs.zsh.dotDir}/.histfile";
    };
  };
}
