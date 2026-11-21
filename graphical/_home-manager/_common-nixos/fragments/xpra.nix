{ pkgs, ... }:
let
  # GDK_BACKEND=wayland (default on wayland) breaks tooltips and context menus
  xpra-x11 = pkgs.symlinkJoin {
    name = "xpra-x11";
    paths = [ pkgs.xpra ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/xpra \
        --set GDK_BACKEND x11
    '';
  };
in
{
  home.packages = [
    xpra-x11
  ];
}
