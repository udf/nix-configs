{ pkgs, ... }:

let
  nodeTools = with pkgs.nodePackages; [
    prettier
    eslint
  ];
in
{
  home.packages =
    with pkgs;
    [
      nodejs
    ]
    ++ nodeTools;
}
