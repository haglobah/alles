{pkgs ? import <nixpkgs> }:

pkgs.stdenv.mkDerivation {
  name = "alles";
  src = ./src;

  buildInputs = [
    pkgs.racket
  ];

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.autoPatchelfHook
    pkgs.ncurses
    pkgs.zlib
    pkgs.libgcc
  ];

  buildPhase = ''
    raco exe --gui alles.rkt
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./alles $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/alles \
      --prefix LD_LIBRARY_PATH : ${with pkgs; lib.makeLibraryPath [
          cairo
          fontconfig
          glib
          gmp
          gtk3
          gsettings-desktop-schemas
          libedit
          libjpeg
          libpng
          mpfr
          ncurses
          openssl
          pango
          poppler
          readline
          sqlite
        ]}
  '';
}