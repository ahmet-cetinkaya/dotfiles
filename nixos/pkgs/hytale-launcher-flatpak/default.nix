{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "d31d2a04abe1b2595d72d9ecee653f1aa54b3947bea1c4fb5ade717c90359d12";
  };
  sha256 = "d31d2a04abe1b2595d72d9ecee653f1aa54b3947bea1c4fb5ade717c90359d12";
}
