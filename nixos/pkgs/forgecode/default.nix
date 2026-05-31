{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  installShellFiles,
}: let
  pname = "forgecode";
  version = "2.12.12";
  runtimeLibs = [
    stdenv.cc.cc.lib
  ];

  src =
    if stdenvNoCC.hostPlatform.system == "x86_64-linux"
    then
      fetchurl {
        url = "https://github.com/tailcallhq/forgecode/releases/download/v${version}/forge-x86_64-unknown-linux-gnu";
        sha256 = "sha256-L/WuBkAF/c9YCPIxg3FqTpAXGvTT8xAyQt+H+A3EacE=";
      }
    else if stdenvNoCC.hostPlatform.system == "aarch64-linux"
    then
      fetchurl {
        url = "https://github.com/tailcallhq/forgecode/releases/download/v${version}/forge-aarch64-unknown-linux-gnu";
        sha256 = "sha256-HHdW8JxZf5uYu+AwGEjJROF+dk3dJ/F5Sj3YdjAFz+8=";
      }
    else throw "Unsupported system for ${pname}: ${stdenvNoCC.hostPlatform.system}";
in
  stdenvNoCC.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      installShellFiles
    ];

    buildInputs = runtimeLibs;

    unpackPhase = ''
      cp $src forge
      chmod +x forge
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 forge $out/bin/forge

      runHook postInstall
    '';

    meta = with lib; {
      description = "An AI-powered code assistant CLI tool";
      homepage = "https://github.com/tailcallhq/forgecode";
      license = licenses.asl20;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mainProgram = "forge";
      maintainers = [];
    };
  }
