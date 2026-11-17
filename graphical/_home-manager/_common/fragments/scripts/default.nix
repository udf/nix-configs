{ customUtils, ... }:
let
  inherit (customUtils) listImportable;
in
{
  imports = builtins.filter (p: p != ./default.nix) (listImportable ./.);
}
