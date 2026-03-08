{
  lib,
  fetchFromGitHub,
  pkgs,
  pkg-config,
  cmake,
  gettext,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "kvirc";
  version = "2025-11-29";

  buildInputs = with pkgs.kdePackages; [
    qtbase
    qtmultimedia
    qtsvg
    qt5compat
  ];

  src = pkgs.fetchFromGitHub {
    owner = "kvirc";
    repo = "KVIrc";
    rev = "ba18690abb4f5ce77bb10164ee0835cc150f4a2a";
    hash = "sha256-1548iYmzBMW595/tX1EmlZ5Gi749exZPgMIBBS8oLmc=";
  };
  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    pkgs.kdePackages.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Advanced IRC Client";
    homepage = "https://www.kvirc.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.suhr ];
    platforms = platforms.linux;
  };
}
