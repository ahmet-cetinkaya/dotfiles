{pkgs, ...}: {
  # Flatpak
  services.flatpak.packages = [
    # Platforms
    "com.valvesoftware.Steam"
    # Games
    pkgs."hytale-launcher-flatpak"
  ];
}
