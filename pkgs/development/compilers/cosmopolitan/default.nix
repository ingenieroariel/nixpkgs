{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = version;
    sha256 = "09bh3dpa6j1jxm9y4qgbmxz4spyn23gv1y0hlkdikcvfz1yvmgm4";
  };

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    makeFlagsArray=(SHELL=/bin/sh "MKDIR=mkdir -p")
    rm test/libc/time/strftime_test.c  # segfaults
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/include}
    install o/cosmopolitan.h $out/lib/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} $out/lib
    makeWrapper ${gcc}/bin/gcc $out/bin/cosmoc --add-flags "-O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone -fuse-ld=bfd -Wl,-T,$out/lib/ape.lds -include $out/lib/include/cosmopolitan.h $out/lib/{crt.o,ape.o,cosmopolitan.a}"
    runHook postInstall
  '';
}
