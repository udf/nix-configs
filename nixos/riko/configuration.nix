{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../_autoload.nix ./.)
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "riko";
    networkmanager.enable = true;
  };

  time.timeZone = "Africa/Johannesburg";

  i18n.defaultLocale = "en_ZA.UTF-8";
  i18n.extraLocales = [ "en_GB.UTF-8/UTF-8" ];

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-qt;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
