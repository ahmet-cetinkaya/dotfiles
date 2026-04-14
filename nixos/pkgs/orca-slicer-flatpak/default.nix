{
  appId = "io.github.softfever.OrcaSlicer";
  bundle = builtins.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.3.2/OrcaSlicer-Linux-flatpak_V2.3.2_x86_64.flatpak";
    sha256 = "1e8d2b91e0c7da1e8c50018d51877f2db438e3c33613318e62fd6775f57a956f";
  };
  sha256 = "sha256-l3uen+yexJeAUx4AJuUaKFyjW8v49Bb0GMTgPHB8EDI=";
}
