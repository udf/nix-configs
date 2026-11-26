{
  config,
  lib,
  pkgs,
  ...
}:
let
  sockSend = pkgs.pkgsStatic.writeCBin "sock-send" ''
    #include <sys/socket.h>
    #include <sys/uio.h>
    #include <sys/un.h>
    #include <unistd.h>
    #include <string.h>

    int main(int argc, char **argv) {
      if (argc < 3) return 1;
      int fd = socket(AF_UNIX, SOCK_STREAM, 0);
      if (fd < 0) return 1;

      struct sockaddr_un addr = { .sun_family = AF_UNIX };
      strncpy(addr.sun_path, argv[1], sizeof(addr.sun_path) - 1);

      int ret = 1;
      if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) == 0) {
        struct iovec iov[2] = {
          { .iov_base = argv[2], .iov_len = strlen(argv[2]) },
          { .iov_base = "\n",    .iov_len = 1 }
        };
        if (writev(fd, iov, 2) >= 0) {
          ret = 0;
        }
      }
      close(fd);
      return ret;
    }
  '';

  sockPath = "/run/user/${toString config.home.uid}/playerctld-seekd.sock";
  seekCmd = offset: ''"${lib.getExe sockSend}" "${sockPath}" "${offset}";'';
in
{
  home.packages = [ pkgs.socat ];

  custom.niri.extraConfigFiles = [
    (pkgs.writeTextFile {
      name = "binds-playerctld-seekd.kdl";
      text = ''
        binds {
          Mod+XF86AudioRaiseVolume { spawn ${seekCmd "2000000"} }
          Mod+XF86AudioLowerVolume { spawn ${seekCmd "-2000000"} }
          Mod+Alt+TouchpadScrollLeft { spawn ${seekCmd "1000000"} }
          Mod+Alt+TouchpadScrollRight { spawn ${seekCmd "-1000000"} }
        }
      '';
    })
  ];
}
