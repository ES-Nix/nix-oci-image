{ pkgs ? import <nixpkgs> { } }:
let
  toybox = pkgs.fetchurl {
    url = "https://landley.net/toybox/downloads/toybox-0.8.4.tar.gz";
    hash = "sha256-yypWWo0wAV0I1zYoeV3KUahbmbFJrqu77Nno29vY/dw=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "toybox-static";
  phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" "fixupPhase" ];

  unpackPhase = ''
    mkdir -p $out

    tar -xf ${toybox} -C $out --strip-components=1
    ls -ahl $out
    sha256sum ${toybox}
    exit 1
  '';

  #makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = with pkgs; [
    bashInteractive
    binutils
    coreutils
    gcc
    glibc # ldd ? glibc.dev?
    glibc.dev
    gzip
    linuxHeaders
    gnumake
    musl
    musl.dev
    gnutar
    stdenv
  ];

  configurePhase = ''
    make allnoconfig
  '';

  buildPhase = ''
    ls -al $out
    cat $out/configure
    make BUILTIN=1
  '';

  installPhase = ''
    mkdir --parent $out/bin

    ls -ahl $out

  '';
}
