sourceDir:
{ customUtils, ... }:
let
  inherit (customUtils) listImportables;
in
{
  imports = listImportables [
    ./_common/fragments
    ./_common/modules
    (sourceDir + "/fragments")
  ];
}
