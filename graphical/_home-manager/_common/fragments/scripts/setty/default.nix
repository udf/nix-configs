{ lib, pkgs, ... }:
{
  namedPackages.setty = pkgs.writers.writePython3Bin "setty" {
    libraries = [ pkgs.python3Packages.boltons ];
    flakeIgnore = [
      "E111"
      "E121"
      "E114"
      "E722"
    ];
  } (builtins.readFile ./setty.py);
}
