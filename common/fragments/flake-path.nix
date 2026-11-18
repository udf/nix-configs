{ inputs, ... }: {
  environment.etc."current-system-flake".source = inputs.self;
}
