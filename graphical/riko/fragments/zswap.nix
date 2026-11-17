{ ... }: {
  boot.zswap = {
    enable = true;
    acceptThresholdPercent = 90;
    compressor = "zstd";
    maxPoolPercent = 33;
    shrinkerEnabled = true;
  };
}
