{pkgs, ...}: {
  services.flatpak.packages = [
    "org.bleachbit.BleachBit"
    "org.kde.filelight"
  ];

  environment.systemPackages = with pkgs; [
    gcc
    clang
    cmake
    ninja
    docker
    docker-compose
    podman
    gh
    curl
    wget
    git
    ripgrep
    fd
    eza
    zoxide
    btop
    fastfetch
    unzip
    zip
    tree
    neovim
    nano
    pkg-config
    konsave
  ];

  programs.kdeconnect.enable = true;
}
