sourceDir:
{
  lib,
  customUtils,
  ...
}@args:
let
  inherit (customUtils) listImportables;
in
{
  imports = listImportables (
    [
      ./_common/fragments
      ./_common/modules
      (sourceDir + "/fragments")
    ]
    ++ (lib.optionals (builtins.hasAttr "osConfig" args) [
      ./_common-nixos/fragments
      ./_common-nixos/modules
    ])
  );
}
