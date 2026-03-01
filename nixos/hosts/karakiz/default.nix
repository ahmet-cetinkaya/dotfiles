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
    ../../modules/core/printing.nix
    ../../modules/core/sound.nix
    ../../modules/core/system.nix
    ../../modules/core/users.nix
    ../../modules/core/virtualisation.nix
    # Desktop
    ../../modules/desktop/nvidia.nix
    ../../modules/desktop/plasma.nix
    # Apps
    ../../modules/apps/browsers.nix
    ../../modules/apps/development.flutter.nix
    ../../modules/apps/development.nix
    ../../modules/apps/games.nix
    ../../modules/apps/media.nix
    ../../modules/apps/productivity.nix
    ../../modules/apps/social.nix
    ../../modules/apps/terminal.nix
    ../../modules/apps/tools.nix
  ];

  networking.hostName = "karakiz";

  # Development
  nixpkgs.config.android_sdk.accept_license = true;
}
