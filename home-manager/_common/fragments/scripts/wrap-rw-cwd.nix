{ lib, pkgs, ... }:
{
  namedPackages.ro-cwd = pkgs.writeShellScriptBin "wrap-rw-cwd" ''
    bwrap_bin="$(command -v bwrap 2>/dev/null || true)"
    if [ -z "$bwrap_bin" ]; then
      bwrap_bin="${lib.getExe pkgs.bubblewrap}"
    fi

    if [[ "''${NIX_CONFIG-}" != *"eval-cache = false"* ]]; then
      NIX_CONFIG+=$'\neval-cache = false'
    fi
    export NIX_CONFIG

    exec "$bwrap_bin" \
      --ro-bind / / \
      --bind "$PWD" "$PWD" \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --tmpfs "$HOME/.ssh" \
      --unshare-user --unshare-pid --unshare-uts --unshare-ipc \
      --die-with-parent -- "$@"
  '';
}
