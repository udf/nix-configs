sourceDir:
{ customUtils, ... }:
let
  inherit (customUtils) listImportable;
in
{
  imports = (
    (listImportable ../common/fragments)
    ++ (listImportable ../common/modules)
    ++ (listImportable ./_common/fragments)
    ++ (listImportable ./_common/modules)
    ++ (listImportable (sourceDir + "/fragments"))
  );
}
