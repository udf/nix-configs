{ nixos-raspberrypi, ... }:
{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-4.base
    raspberry-pi-4.display-vc4
    raspberry-pi-4.bluetooth

    trusted-nix-caches
  ];

  # boot.loader.raspberry-pi.bootloader = "kernel";
}
