{pkgs, ...}: {
  services.flatpak.packages = [
    "io.dbeaver.DBeaverCommunity"
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
    csharpier
    ## Java
    jdk17
    gradle
    ktfmt
    ## Rust
    rustc
    cargo
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
    claude-code
    opencode

    # Nix Tools
    alejandra
    statix
    deadnix
  ];
}
