{ lib, ... }:
with lib;
{
  listFilesWithExt =
    {
      dir,
      ext,
      relative ? false,
    }:
    map (f: if relative then "${f}" else d + "/${f}") (
      attrNames (filterAttrs (k: v: (v == "regular" && hasSuffix ext k)) (readDir dir))
    );

  listImportable =
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
}
