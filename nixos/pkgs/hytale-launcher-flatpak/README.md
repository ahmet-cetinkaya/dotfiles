# Hytale Launcher NixOS Flake Configuration

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![Flatpak](https://img.shields.io/badge/Flatpak-4A90D9?logo=flatpak&logoColor=white)](https://flatpak.org)

A NixOS package for the **Hytale Launcher** distributed as a Flatpak bundle. Provides the official game launcher from Hypixel Studios for managing and launching Hytale.

**App ID:** `com.hypixel.HytaleLauncher`

---

## Prerequisites

The [nix-flatpak](https://github.com/gmodena/nix-flatpak) module must be added as a flake input and imported, and Flatpak must be enabled:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { nixpkgs, nix-flatpak, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        {
          services.flatpak.enable = true;
          services.flatpak.remotes = [
            {
              name = "flathub";
              location = "https://flathub.org/repo/flathub.flatpakrepo";
            }
          ];
        }
      ];
    };
  };
}
```

## Installation

Add the package overlay and include it in `services.flatpak.packages`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    configs.url = "github:ahmet-cetinkaya/dotfiles";
  };

  outputs = { nixpkgs, nix-flatpak, configs, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        {
          nixpkgs.overlays = [ (import "${configs}/pkgs") ];
          services.flatpak.enable = true;
          services.flatpak.remotes = [
            {
              name = "flathub";
              location = "https://flathub.org/repo/flathub.flatpakrepo";
            }
          ];
          services.flatpak.packages = [
            pkgs."hytale-launcher-flatpak"
          ];
        }
      ];
    };
  };
}
```

---

## Updating

An update script is provided to fetch the latest Flatpak bundle and update the SHA256 hash automatically:

```bash
./update.sh
```

The script:
1. Downloads the latest release from `launcher.hytale.com`
2. Computes the SHA256 hash
3. Updates `default.nix` with the new hash

---

## Package Structure

```text
hytale-launcher-flatpak/
├── default.nix       # Nix package definition (appId, bundle URL, sha256)
├── update.sh         # Script to fetch latest bundle and update hashes
└── README.md
```

---

## License

Hytale Launcher is property of Hypixel Studios. This package definition is provided as-is for NixOS integration purposes.
