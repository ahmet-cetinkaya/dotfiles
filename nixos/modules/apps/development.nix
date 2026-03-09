{pkgs, ...}: {
  imports = [
    ./development.flutter.nix
    ./development.tools-dotnet.nix
    ./development.tools-uv.nix
    ./development.tools-bun.nix
    ./development.fonts.nix
  ];

  # Flatpak
  services.flatpak.packages = [
    # Database
    "io.dbeaver.DBeaverCommunity"
    # Containers
    "io.podman_desktop.PodmanDesktop"
  ];

  environment.systemPackages = with pkgs; [
    # Languages & Runtimes
    ## C/C++
    clang
    cmake
    ninja
    pkg-config

    ## JS
    nodejs
    bun
    prettier

    ## Go
    go

    ## .NET
    dotnet-sdk

    ## Java
    jdk17
    gradle
    ktfmt

    ## Rust
    rustc
    cargo
    rustfmt

    ## Python
    python3
    uv

    ## Shell
    shellcheck
    shfmt

    ## Lua
    stylua

    ## TOML
    taplo

    # Editors
    neovim
    vscodium
    pkgs."zed-preview-bin"

    # Tools
    git
    gitui
    git-open
    git-ignore

    # Agents
    antigravity

    # Nix Tools
    alejandra
    statix
    deadnix
    nixfmt
  ];

}
