{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gcc,
}:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = "cdc54ea1fd86253ced49dd24d45660cadac1d018";
    hash = "sha256-vIDNWaM2+ztwx9hknl5+3ENkx9FxH7/VQ8uUW/sckyg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  preBuild = ''
    makeFlagsArray=(SHELL=/bin/sh "MKDIR=mkdir -p")
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
