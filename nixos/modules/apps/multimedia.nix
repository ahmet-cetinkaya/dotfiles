_: {
  # Services
  home-manager.users.ac = {
    services.easyeffects.enable = true;
  };

  # Flatpak
  services.flatpak.packages = [
    # Video Players
    "io.mpv.Mpv"
    # Video Editing
    "org.kde.kdenlive"
    # Streaming
    "com.stremio.Stremio"
    # Cloud Storage
    "com.nextcloud.desktopclient.nextcloud"
  ];
}
