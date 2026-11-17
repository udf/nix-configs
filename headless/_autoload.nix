sourceDir:
{ customUtils, ... }:
let
  inherit (customUtils) listImportable;
in
{
  imports = (
    (listImportable ../common/fragments)
    ++ (listImportable ../common/modules)
    ++ (listImportable (sourceDir + "/fragments"))
  );
}
