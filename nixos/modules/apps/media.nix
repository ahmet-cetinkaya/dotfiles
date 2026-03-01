_: {
  home-manager.users.ac = {
    services.easyeffects.enable = true;
  };

  services.flatpak.packages = [
    "org.kde.kdenlive"
    "io.mpv.Mpv"
    "com.stremio.Stremio"
    "org.blender.Blender"
    "org.inkscape.Inkscape"
    "com.nextcloud.desktopclient.nextcloud"
  ];
}
