{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Videos
    ffmpeg
    ffmpegthumbnailer

    # Images
    gdk-pixbuf
    # HEIF container support (this includes the AVIF file format)
    libheif.bin
    # More newer AVIF specific support usually not needed if libheif is installed
    libavif
    # JXL(JPEG XL) support
    libjxl
    # WebP support
    webp-pixbuf-loader

    # 3D models
    f3d
  ];
}
