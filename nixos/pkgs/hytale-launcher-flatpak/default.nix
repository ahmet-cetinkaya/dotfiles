{
  appId = "com.hypixel.HytaleLauncher";
  bundle = builtins.fetchurl {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    sha256 = "d58d409e10370c22f716c55c235e749e22d5b15a90dbe127ec81aa3f7790047b";
  };
  sha256 = "d58d409e10370c22f716c55c235e749e22d5b15a90dbe127ec81aa3f7790047b";
}
