sourceDir:
{ lib, ... }:
let
  listImportable = ((import ./_common/helpers/list-files.nix) { inherit lib; }).listImportable;
in
{
  imports = (
    (listImportable ./_common/fragments)
    ++ (listImportable ./_common/modules)
    ++ (listImportable (sourceDir + "/fragments"))
  );
}
