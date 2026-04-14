{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  webkitgtk_4_1,
  libappindicator,
  openssl,
  glib,
  libgcc,
  libX11,
}:

let
  pname = "antigravity-tools-bin";
  version = "4.1.31";
  runtimeLibs = [
    gtk3
    webkitgtk_4_1
    libappindicator
    openssl
    glib
    libgcc
    libX11
  ];
  src = fetchurl {
    url = "https://github.com/lbjlaq/Antigravity-Manager/releases/download/v${version}/Antigravity.Tools_${version}_amd64.deb";
    sha256 = "18b88ab5f66bed09679dd4e352fc53b5bed6b9c9324b65f0e21891ad9d6b8658";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    libappindicator
    openssl
    glib
    libgcc
    libX11
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p extracted
    dpkg-deb -x $src extracted
    runHook postUnpack
  '';

  sourceRoot = "extracted";

  installPhase = ''
    runHook preInstall

    install -d "$out/bin" "$out/lib" "$out/share/applications" "$out/share/licenses/antigravity-tools-bin"

    if [ -d "usr/local" ]; then
      cp -a usr/local/. "$out/"
    elif [ -d "usr" ]; then
      cp -a usr/. "$out/"
    fi

    if [ -f "$out/share/licenses/antigravity-tools-bin/LICENSE" ]; then
      install -Dm644 "$out/share/licenses/antigravity-tools-bin/LICENSE" "$out/share/licenses/antigravity-tools-bin/LICENSE"
    fi

    for exe in $(find "$out/bin" -maxdepth 1 -type f -executable); do
      cp "$exe" "$exe.real"
      chmod -x "$exe"
      makeWrapper "$exe.real" "$exe" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Professional Antigravity Account Manager & Switcher";
    homepage = "https://github.com/lbjlaq/Antigravity-Manager";
    license = "custom";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
