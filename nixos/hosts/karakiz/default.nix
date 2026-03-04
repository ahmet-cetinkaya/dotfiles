{...}: {
  imports = [
    ./hardware-configuration.nix
    # Core
    ../../modules/core/bluetooth.nix
    ../../modules/core/boot.nix
    ../../modules/core/dpi.nix
    ../../modules/core/flatpak.nix
    ../../modules/core/fonts.nix
    ../../modules/core/locale.nix
    ../../modules/core/network.nix
    ../../modules/core/nvidia.nix
    ../../modules/core/plasma.nix
    ../../modules/core/printing.nix
    ../../modules/core/sound.nix
    ../../modules/core/swap.nix
    ../../modules/core/system.nix
    ../../modules/core/users.nix
    # Apps
    # Development
    ../../modules/apps/development.flutter.nix
    ../../modules/apps/development.nix
    # Games
    ../../modules/apps/games.nix
    # Graphics
    ../../modules/apps/graphics.nix
    # Internet
    ../../modules/apps/internet.nix
    # Multimedia
    ../../modules/apps/multimedia.nix
    # Productivity
    ../../modules/apps/productivity.nix
    # Utilities
    ../../modules/apps/utilities.nix
  ];

  networking.hostName = "karakiz";

  # Development
  nixpkgs.config.android_sdk.accept_license = true;
}
