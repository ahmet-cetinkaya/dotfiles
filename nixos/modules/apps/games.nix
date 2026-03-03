{pkgs, ...}: {
  # Flatpak
  services.flatpak.packages = [
    # Steam
    "com.valvesoftware.Steam"
    pkgs."hytale-launcher-flatpak"
  ];
}
