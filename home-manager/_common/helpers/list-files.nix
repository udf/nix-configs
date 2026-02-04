{ lib, pkgs, ... }:
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
}
