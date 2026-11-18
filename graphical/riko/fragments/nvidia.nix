{
  config,
  pkgs,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    kernelParams = [
      "nvidia-drm.fbdev=0"
      "nvidia.NVreg_DynamicPowerManagement=0x03"
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
        offloadCmdMainProgram = "nvidia-offload-old";
      };
    };
  };

  # Use AMD GPU by default
  environment.sessionVariables = {
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvidia-offload" ''
      unset VK_DRIVER_FILES
      exec nvidia-offload-old "$@"
    '')
  ];

}
