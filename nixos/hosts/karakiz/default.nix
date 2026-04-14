{ ... }:
{
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
    ../../modules/apps/development
    # Games
    ../../modules/apps/games.nix
    # AI/ML
    ../../modules/apps/ai.nix
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

  boot.loader.systemd-boot = {
    extraEntries."windows11-atlas.conf" = ''
      title Windows 11 Atlas OS
      efi /EFI/Microsoft/Boot/bootmgfw.efi
      sort-key o_windows_11_atlas
    '';
    extraInstallCommands = ''
      printf '\nauto-entries no\n' >> /boot/loader/loader.conf
    '';
  };

}
