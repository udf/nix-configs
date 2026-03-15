{lib, pkgs, ...}:
{
  namedPackages.ro-cwd = pkgs.writeShellScriptBin "wrap-rw-cwd" ''
    ${lib.getExe pkgs.bubblewrap} \
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