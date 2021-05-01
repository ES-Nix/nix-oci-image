{ pkgs ? import <nixpkgs> { } }:

pkgs.dockerTools.buildImage {
  name = "build-environment-to-build-toybox-staticaly";
  tag = "0.0.1";

  contents = with pkgs; [
    bashInteractive
    binutils
    coreutils
    gcc
    glibc # ldd ? glibc.dev?
    gzip
    linuxHeaders
    gnumake
    musl
    musl.dev
    gnutar
    stdenv
    wget
  ];

  config = {
    Cmd = [ "bash" ];
  };
}
