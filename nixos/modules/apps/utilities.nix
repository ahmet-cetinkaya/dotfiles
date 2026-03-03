{pkgs, ...}: {
  users.users.ac.shell = pkgs.zsh;

  # Flatpak
  services.flatpak.packages = [
    # System Tools
    "org.bleachbit.BleachBit"
    "org.kde.filelight"
    pkgs."orca-slicer-flatpak"
  ];

  # OpenRGB with all plugins for RGB hardware control
  services.hardware.openrgb.enable = true;

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

  environment.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs = {
    kdeconnect.enable = true;

    # Shell
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
        update = "sudo nixos-rebuild switch";
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
