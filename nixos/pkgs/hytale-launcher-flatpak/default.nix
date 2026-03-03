{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "sha256-hjCJuRBT7yY/KWz3M3lZLroOMSWs42dhlGt002srKgw=";
  };
  sha256 = "sha256-hjCJuRBT7yY/KWz3M3lZLroOMSWs42dhlGt002srKgw=";
}
