{
  config,
  lib,
  pkgs,
  ...
}:
{
  namedPackages.ro-cwd = pkgs.writeShellScriptBin "wrap-ro-cwd" ''
    bwrap_bin="$(command -v bwrap 2>/dev/null || true)"
    if [ -z "$bwrap_bin" ]; then
      bwrap_bin="${lib.getExe pkgs.bubblewrap}"
    fi

    if [[ "''${NIX_CONFIG-}" != *"eval-cache = false"* ]]; then
      NIX_CONFIG+=$'\neval-cache = false'
    fi
    export NIX_CONFIG
    export XDG_CACHE_HOME="/tmp/scratch/cache"

    exec "$bwrap_bin" \
      --ro-bind / / \
      --bind /tmp /tmp \
      --bind "$PWD" "$PWD" \
      --dev /dev \
      --proc /proc \
      --tmpfs "$HOME/.ssh" \
      --tmpfs "/tmp/scratch" \
      --unshare-user --unshare-pid --unshare-uts --unshare-ipc \
      --die-with-parent -- "$@"
  '';

  namedPackages.ro-cwd-zsh = pkgs.writeShellScriptBin "ro-cwd-zsh" ''
    exec ${lib.getExe config.namedPackages.ro-cwd} zsh "$@"
  '';
}
