{pkgs, ...}: {
  # Flatpak
  services.flatpak.packages = [
    # Platforms
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    # Games
    pkgs."hytale-launcher-flatpak"
  ];
}
