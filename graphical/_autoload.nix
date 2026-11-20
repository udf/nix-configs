sourceDir:
{ inputs, customUtils, ... }:
let
  inherit (customUtils) listImportables;
in
{
  imports = listImportables [
    (inputs.self + /common/fragments)
    (inputs.self + /common/modules)
    ./_common/fragments
    ./_common/modules
    (sourceDir + /fragments)
  ];
}
