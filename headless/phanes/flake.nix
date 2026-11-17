{
  description = "Phanes flake inputs";

  inputs = {
    # MARK: pinned version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {
    inherit inputs;
  };
}
