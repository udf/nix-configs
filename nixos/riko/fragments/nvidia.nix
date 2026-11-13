{
  config,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    extraModprobeConfig = ''
      options nvidia NVreg_DynamicPowerManagement=0x03
    '';
    kernelParams = [
      "nvidia-drm.fbdev=0"
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      amdgpuBusId = "PCI:8:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
