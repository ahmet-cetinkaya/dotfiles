{
  lib,
  pkgs,
  ...
}: {
  home.activation.orcaSlicerFlatpakOverride = lib.mkAfter ''
    # Work around blank preview/prepare pages on NVIDIA with OrcaSlicer Flatpak.
    ${pkgs.flatpak}/bin/flatpak override --user --env=GBM_BACKEND=dri io.github.softfever.OrcaSlicer || true
  '';
}
