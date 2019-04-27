{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:
let
  srcSpec = import ./src.nix;
  shortRev = builtins.substring 0 7 srcSpec.rev;
in stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.8-${shortRev}";

  src = fetchgit srcSpec;

  patches = [ ./fix-Makefiles.patch ];

  nativeBuildInputs = [ asciidoc libxslt ];

  outputs = [ "out" "lib" "dev" "man" ];

  MANPAGE_DOCBOOK_XSL="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  buildPhase = "make trace-cmd libs doc";

  installTargets = [ "install_cmd" "install_libs" "install_man" ];
  installFlags = [
    "bindir=${placeholder "out"}/bin"
    "man_dir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "includedir=${placeholder "dev"}/include/trace-cmd"
    "BASH_COMPLETE_DIR=${placeholder "out"}/etc/bash_completion.d"
  ];

  meta = with stdenv.lib; {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    homepage    = http://kernelshark.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice basvandijk ];
  };
}
