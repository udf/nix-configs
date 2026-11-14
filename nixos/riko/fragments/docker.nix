{ ... }:
{
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "overlay2";
    };
    oci-containers.backend = "docker";
  };

  users.users.sam.extraGroups = [ "docker" ];
}
