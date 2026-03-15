{ lib, pkgs, ... }:
let 
  listImportable =
    ((import ../../helpers/list-files.nix) { inherit lib pkgs; }).listImportable;
in 
{
  imports = builtins.filter (p: p != ./default.nix) (listImportable ./.);
}
