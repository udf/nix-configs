{ lib, pkgs, ... }:

with lib;
let
  # inject "--minimum 1M" into upstream args
  upstreamUnit = builtins.readFile "${pkgs.util-linux}/lib/systemd/system/fstrim.service";
  execLine = head (filter (line: hasPrefix "ExecStart=" line) (splitString "\n" upstreamUnit));
  patchedExec = replaceStrings [ "fstrim " ] [ "fstrim --minimum 1M " ] (
    removePrefix "ExecStart=" execLine
  );
in
{
  services.fstrim.enable = true;

  systemd.services.fstrim.serviceConfig = {
    ExecStart = lib.mkForce [
      ""
      patchedExec
    ];
    IOSchedulingClass = "best-effort";
    IOSchedulingPriority = 7;
    Nice = 19;
  };
}
