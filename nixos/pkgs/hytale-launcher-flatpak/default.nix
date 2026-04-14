{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "665b01688a9ad06693722ed09119f07dc001c92e022f9a2c5db6b6a74804f824";
  };
  sha256 = "665b01688a9ad06693722ed09119f07dc001c92e022f9a2c5db6b6a74804f824";
}
