{lib, pkgs, ...}: {
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
    claude-code
    opencode

    # Nix Tools
    alejandra
    statix
    deadnix
  ];

  # Languages & Runtimes ## Dotnet
  home-manager.users.ac.home.activation.dnvmInstall = lib.mkAfter ''
    if [ -x "$HOME/.local/share/dnvm/dn/dnvm" ] || [ -x "$HOME/.dnvm/bin/dnvm" ] || command -v dnvm >/dev/null 2>&1; then
      echo "dnvm is already installed."
    else
      echo "Installing dnvm..."
      if ! curl --proto '=https' -sSf https://dnvm.net/install.sh | sh -s -- -y; then
        echo "dnvm installation failed. Run manually: curl --proto '=https' -sSf https://dnvm.net/install.sh | sh" >&2
      fi
    fi
  '';
}
