sourceDir:
{ lib, ... }:
with builtins;
with lib;
let
  listFiles =
    dir:
    map (f: dir + "/${f}") (
      attrNames (
        filterAttrs (
          k: v:
          (v == "regular" && hasSuffix ".nix" k)
          || (v == "directory" && pathExists ((dir + "/${k}/default.nix")))
        ) (readDir dir)
      )
    );
in
{
  imports = (
    (listFiles ./_common/fragments)
    ++ (listFiles ./_common/modules)
    ++ (listFiles (sourceDir + "/fragments"))
  );
}
