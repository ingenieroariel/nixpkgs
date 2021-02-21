{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "0.2";

  src = fetchzip {
    url = "https://justine.lol/cosmopolitan/cosmopolitan-${version}.tar.gz";
    sha256 = "09bh3dpa6j1jxm9y4qgbmxz4spyn23gv1y0hlkdikcvfz1yvmgm4";
  };

  preBuild = ''
    makeFlagsArray+=("SHELL=sh" "DD=dd" "CP=cp" "RM=rm" "SED=sed" "MKDIR=mkdir -p")
  '';
}
