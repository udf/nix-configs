{
  description = "Durga flake inputs";

  inputs = {
    # MARK: pinned version
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    inherit inputs;
  };
}
