{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "tmp";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/etc/pki/tls/certs
    ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/pki/tls/certs/ca-bundle.crt
  '';
}
