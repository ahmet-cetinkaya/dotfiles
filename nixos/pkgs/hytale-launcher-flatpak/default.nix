{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "d2ae6a0a4312af4da345fe78642aa698b6bca951ebf8eca3543d99deef3d6d71";
  };
  sha256 = "d2ae6a0a4312af4da345fe78642aa698b6bca951ebf8eca3543d99deef3d6d71";
}
