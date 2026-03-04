{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "sha256-W/aVRHVaWIP43w5xucU/0Zu6JgsPfgMgLPn9M4rhLrE=";
  };
  sha256 = "sha256-W/aVRHVaWIP43w5xucU/0Zu6JgsPfgMgLPn9M4rhLrE=";
}
