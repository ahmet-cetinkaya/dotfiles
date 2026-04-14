# OrcaSlicer NixOS Flake Configuration

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![Flatpak](https://img.shields.io/badge/Flatpak-4A90D9?logo=flatpak&logoColor=white)](https://flatpak.org)
[![GitHub release](https://img.shields.io/github/v/release/OrcaSlicer/OrcaSlicer)](https://github.com/OrcaSlicer/OrcaSlicer/releases/latest)

A NixOS package for **OrcaSlicer** distributed as a Flatpak bundle. OrcaSlicer is a high-performance, open-source slicer for 3D printing based on PrusaSlicer/BambuStudio.

**App ID:** `io.github.softfever.OrcaSlicer`

**Core Techs:**
[![Nix](https://img.shields.io/badge/Nix-5277C3?logo=nixos&logoColor=white)](https://nixos.org)

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
            pkgs."orca-slicer-flatpak"
          ];
        }
      ];
    };
  };
}
```

---

## Updating

An update script is provided to automatically fetch the latest OrcaSlicer release from GitHub:

```bash
./update.sh
```

The script:
1. Queries the GitHub API for the latest release of [OrcaSlicer](https://github.com/OrcaSlicer/OrcaSlicer)
2. Downloads the Flatpak asset for the new version
3. Computes the SHA256 hash
4. Updates `default.nix` with the new version URL and hash

---

## Package Structure

```text
orca-slicer-flatpak/
├── default.nix       # Nix package definition (appId, bundle URL, sha256)
├── update.sh         # Script to fetch latest release and update hashes
└── README.md
```

---

## License

OrcaSlicer is licensed under the **GNU General Public License v3.0**. See the [OrcaSlicer repository](https://github.com/OrcaSlicer/OrcaSlicer) for details.
