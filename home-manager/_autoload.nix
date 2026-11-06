sourceDir:
{ customUtils, ... }:
let
  inherit (customUtils) listImportable;
in
{
  imports = (
    (listImportable ./_common/fragments)
    ++ (listImportable ./_common/modules)
    ++ (listImportable (sourceDir + "/fragments"))
  );
}
