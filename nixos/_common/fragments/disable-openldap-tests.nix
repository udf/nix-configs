{ ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/514113
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
