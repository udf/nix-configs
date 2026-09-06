{
  description = "Riko flake inputs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Third party sources
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-virtual-outputs = {
      url = "github:willybarret/niri/wip/virtual-outputs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      # MARK: pinned version
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit/948aa87003f6c94080650804a6974182e5948ca1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # MARK: pinned version
    nix-colorizer.url = "github:nutsalhan87/nix-colorizer/c9ce6c710f4ed749f773104a8092a3e542dd1d7c";
  };

  outputs = inputs: {
    inherit inputs;
    extraModules = [ inputs.catppuccin.nixosModules.catppuccin ];
    extraHomeManagerModules = [ inputs.catppuccin.homeModules.catppuccin ];
  };
}
