{
  description = "Ananke flake inputs";

  inputs = {
    # MARK: pinned version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # TODO: unpin this back to /master
    nixos-hardware.url = "github:NixOS/nixos-hardware/7aefd9ab01eef691c5c688d9ca4d1ea003cca284";
  };

  outputs = inputs: {
    inherit inputs;
  };
}
