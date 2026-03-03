final: _prev: {
  orca-slicer-flatpak = import ./orca-slicer-flatpak;
  zed-preview-bin = final.callPackage ./zed-preview-bin {};
  hytale-launcher-flatpak = import ./hytale-launcher-flatpak;
}
