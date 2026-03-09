{pkgs, ...}: {
  # Flatpak
  services.flatpak.packages = [
    # System Tools
    "org.bleachbit.BleachBit"
    "org.kde.filelight"
    "org.kde.isoimagewriter"
  ];

  environment.systemPackages = with pkgs; [
    # Terminal
    kitty

    # CLI Utilities
    fastfetch
    eza
    zoxide
    btop
    jq
    nano

    # Download Tools
    curl
    wget

    # Version Control
    git
    gh

    # Search Tools
    ripgrep
    fd

    # Archive Tools
    unzip
    zip
    tree

    # Build Tools
    pkg-config
    gnumake
    gcc
    clang
    cmake
    ninja

    # Containers
    docker
    docker-compose
    podman

    # System Tools
    konsave
    gparted
    openrgb-with-all-plugins
  ];

  # OpenRGB with all plugins for RGB hardware control
  services.hardware.openrgb.enable = true;

  # Containers
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  programs.kdeconnect.enable = true;

  # Shell
  users.users.ac.shell = pkgs.zsh;

  environment.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        plugins = ["git" "sudo" "docker" "kubectl"];
        theme = "robbyrussell";
      };

      shellAliases = {
        ll = "ls -l";
        ls = "eza --icons=auto";
      };
    };
    starship = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };
}
