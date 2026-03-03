{
  appId = "io.github.softfever.OrcaSlicer";
  bundle = builtins.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.3.1/OrcaSlicer-Linux-flatpak_V2.3.1_x86_64.flatpak";
    sha256 = "sha256-l3uen+yexJeAUx4AJuUaKFyjW8v49Bb0GMTgPHB8EDI=";
  };
  sha256 = "sha256-l3uen+yexJeAUx4AJuUaKFyjW8v49Bb0GMTgPHB8EDI=";
}
