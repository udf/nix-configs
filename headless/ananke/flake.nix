{
  description = "Ananke flake inputs";

  inputs = {
    # MARK: pinned version
    # TODO: unpin these back to /nixos-26.05 and /master
    nixpkgs.url = "github:nixos/nixpkgs/fcb8fcd6bf2d0adecae5bd491afaaaf8311b758d";
    nixos-hardware.url = "github:NixOS/nixos-hardware/7aefd9ab01eef691c5c688d9ca4d1ea003cca284";
  };

  outputs = inputs: {
    inherit inputs;
  };
}
