{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # version control
    git
    git-crypt

    # network and transfer utilities
    wget
    aria2

    # archiving
    zip
    unzip
    atool

    # hardware/system inspection
    tree
    file
    lsof
    lm_sensors
    usbutils
    pciutils
    compsize

    # shell utilities
    jq
    ldns
    moreutils
    ripgrep
    pv
    expect

    # interactive
    ncdu
    tmux
    htop
    iotop-c
    btop
  ];
}
