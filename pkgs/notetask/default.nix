{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus-qt5,
  libx11,
  libsForQt5,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notetask";
  version = "unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "plaintool";
    repo = "notetask";
    rev = "c9e31de5a2fa5125d7cc4c6823cb28609b622b05";
    hash = "sha256-Ua3KuZouad4j8VMvOgBROsy5bsJsvdx7cjwl1isYbLg=";
  };

  nativeBuildInputs = [
    fpc
    lazarus-qt5
    libsForQt5.wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libx11
    libsForQt5.libqtpas
  ];

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  buildPhase = ''
    runHook preBuild

    lazbuild --lazarusdir=${lazarus-qt5}/share/lazarus --ws=qt5 --build-mode=Release \
      notetask.lpi

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 notetask -t $out/bin

    install -Dm644 installer/linux/DATA/usr/share/applications/x-notetask.desktop \
      $out/share/applications/notetask.desktop
    substituteInPlace $out/share/applications/notetask.desktop \
      --replace-fail "/usr/bin/notetask" "$out/bin/notetask"

    cp -r installer/linux/DATA/usr/share/icons $out/share/
    install -Dm644 installer/linux/DATA/usr/share/pixmaps/notetask.png -t $out/share/pixmaps
    install -Dm644 installer/linux/DATA/usr/share/mime/packages/x-notetask.xml \
      -t $out/share/mime/packages

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform task manager and note organizer";
    homepage = "https://github.com/plaintool/notetask";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "notetask";
  };
})
