{
  lib,
  pkgs,
  ...
}: {
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

    # Nix Tools
    alejandra
    statix
    deadnix
    nixfmt
  ];

  # Activation Scripts
  home-manager.users.ac.home.activation.dnvmInstall = lib.mkAfter ''
    is_dnvm_installed() {
      [ -x "$HOME/.local/share/dnvm/dn/dnvm" ] || \
      [ -x "$HOME/.dnvm/bin/dnvm" ] || \
      command -v dnvm >/dev/null 2>&1
    }

    if is_dnvm_installed; then
      echo "dnvm is already installed."
      exit 0
    fi

    echo "Installing dnvm..."
    if ! curl --proto '=https' -sSf https://dnvm.net/install.sh | sh -s -- -y; then
      echo "dnvm installation failed. Run manually: curl --proto '=https' -sSf https://dnvm.net/install.sh | sh" >&2
    fi
  '';

  home-manager.users.ac.home.activation.dotnetGlobalTools = lib.mkAfter ''
    if ! command -v dotnet >/dev/null 2>&1; then
      echo "dotnet not found, skipping dotnet global tools installation."
      exit 0
    fi

    ensure_dotnet_tool_latest() {
      local tool_name="$1"

      if dotnet tool list -g | awk '{print $1}' | grep -qx "$tool_name"; then
        echo "Updating dotnet tool: $tool_name..."
        if ! dotnet tool update -g "$tool_name"; then
          echo "dotnet tool update failed: $tool_name" >&2
        fi
        return
      fi

      echo "Installing dotnet tool: $tool_name..."
      if ! dotnet tool install -g "$tool_name"; then
        echo "dotnet tool installation failed: $tool_name" >&2
      fi
    }

    DOTNET_TOOLS=(
      csharpier
    )

    for tool_name in "''${DOTNET_TOOLS[@]}"; do
      ensure_dotnet_tool_latest "$tool_name"
    done
  '';

  # Add bun global bin to PATH
  home-manager.users.ac.home.sessionPath = [ "$HOME/.bun/bin" ];
  home-manager.users.ac.home.activation.bunGlobalPackages = lib.mkAfter ''
    if ! command -v bun >/dev/null 2>&1; then
      echo "bun not found, skipping bun global packages installation."
      exit 0
    fi

    # package -> expected binary
    declare -A BUN_PACKAGES=(
      ["@google/gemini-cli"]="gemini"
      ["@kilocode/cli"]="kilo"
      ["@anthropic-ai/claude-code"]="claude"
      ["@openai/codex"]="codex"
      ["opencode-ai"]="opencode"
      ["@qwen-code/qwen-code"]="qwen"
    )

    ensure_bun_package_latest() {
      local package="$1"
      local binary="$2"

      if [ -x "$HOME/.bun/bin/$binary" ]; then
        echo "Updating bun global package: $package..."
        if ! bun update -g "$package"; then
          echo "Failed to update bun global package: $package" >&2
        fi
        return
      fi

      echo "Installing bun global package: $package..."
      if ! bun install -g "$package"; then
        echo "Failed to install bun global package: $package" >&2
      fi
    }

    for package in "''${!BUN_PACKAGES[@]}"; do
      ensure_bun_package_latest "$package" "''${BUN_PACKAGES[$package]}"
    done
  '';
}
