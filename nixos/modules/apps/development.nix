{lib, pkgs, ...}: {
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
    nixfmt
  ];

  # Activation Scripts
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

  home-manager.users.ac.home.activation.csharpierDotnetTool = lib.mkAfter ''
    if command -v dotnet >/dev/null 2>&1; then
      if dotnet tool list -g | grep -q "csharpier"; then
        echo "csharpier dotnet tool is already installed."
      else
        echo "Installing csharpier dotnet tool..."
        if ! dotnet tool install -g csharpier; then
          echo "csharpier dotnet tool installation failed." >&2
        fi
      fi
    else
      echo "dotnet not found, skipping csharpier dotnet tool installation."
    fi
  '';
}
