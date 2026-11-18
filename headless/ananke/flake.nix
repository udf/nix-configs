{
  description = "Ananke flake inputs";

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  outputs = inputs: {
    inherit inputs;

    extraModules = [
      {
        nixpkgs.overlays = [
          inputs.nixos-raspberrypi.overlays.bootloader
          inputs.nixos-raspberrypi.overlays.vendor-kernel
          inputs.nixos-raspberrypi.overlays.vendor-firmware
          inputs.nixos-raspberrypi.overlays.vendor-pkgs
          inputs.nixos-raspberrypi.overlays.pkgs
          inputs.nixos-raspberrypi.overlays.kernel-and-firmware
          # disable ffmpeg overlay to avoid compiling python modules
          # (it's also unused on this system)
          (
            _final: _prev:
            let
              upstreamPkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
            in
            {
              ffmpeg = upstreamPkgs.ffmpeg_8;
              ffmpeg-headless = upstreamPkgs.ffmpeg_8-headless;
              ffmpeg-full = upstreamPkgs.ffmpeg_8-full;
              ffmpeg_8 = upstreamPkgs.ffmpeg_8;
              ffmpeg_8-headless = upstreamPkgs.ffmpeg_8-headless;
              ffmpeg_8-full = upstreamPkgs.ffmpeg_8-full;
            }
          )
        ];
      }
    ];
  };
}
