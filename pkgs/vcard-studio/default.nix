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
  pname = "vcard-studio";
  version = "unstable-2022-03-12";

  src = fetchFromGitHub {
    owner = "bitoffdev";
    repo = "vcard-studio";
    rev = "b3c60296b1dd333870ec594eff5e71a2357d9d22";
    hash = "sha256-bXnK2NLyMPtQ151vV6M8df3YZMrvj4tHHimutUuCFd8=";
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
      vCardStudio.lpi

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 vCardStudio -t $out/bin
    install -Dm644 Install/deb/vCardStudio.desktop -t $out/share/applications
    install -Dm644 Install/deb/vCardStudio.png -t $out/share/pixmaps

    install -d $out/share/vCardStudio/Languages
    cp -r Languages/* $out/share/vCardStudio/Languages/
    install -Dm644 Images/Profile.png -t $out/share/vCardStudio/Images

    runHook postInstall
  '';

  postFixup = ''
    mv $out/bin/vCardStudio $out/bin/.vCardStudio-qt-wrapped
    cat > $out/bin/vCardStudio <<EOF
    #!${stdenv.shell}
    cd $out/share/vCardStudio
    exec $out/bin/.vCardStudio-qt-wrapped "$@"
    EOF
    chmod +x $out/bin/vCardStudio
  '';

  meta = {
    description = "Contact manager with support for vCard files";
    homepage = "https://github.com/bitoffdev/vcard-studio";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "vCardStudio";
  };
})
