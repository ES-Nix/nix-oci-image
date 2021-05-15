{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "ca-bundle";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir --parent $out/etc/ssl/certs
    cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt
  '';
}
