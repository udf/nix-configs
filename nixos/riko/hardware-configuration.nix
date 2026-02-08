{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-f1c85b3e-84d7-4bfa-a6ad-c86852feadd8";
    fsType = "btrfs";
    options = [ "relatime" "discard" ];
  };

  boot.initrd.luks.devices."luks-f1c85b3e-84d7-4bfa-a6ad-c86852feadd8".device =
    "/dev/disk/by-uuid/f1c85b3e-84d7-4bfa-a6ad-c86852feadd8";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B5D6-BC15";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  boot.initrd.luks.devices."luks-7e217c3c-3bfa-4f08-8e95-64dd41131447".device =
    "/dev/disk/by-uuid/7e217c3c-3bfa-4f08-8e95-64dd41131447";
  swapDevices = [
    { device = "/dev/mapper/luks-7e217c3c-3bfa-4f08-8e95-64dd41131447"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
