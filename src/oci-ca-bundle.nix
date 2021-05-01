{ pkgs ? import <nixpkgs> { } }:
let
  caBundle = pkgs.stdenv.mkDerivation {
      name = "ca-bundle";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir --parent $out/etc/ssl/certs
        cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt
        mkdir $out/etc/foo-bar.txt
      '';
    };
in
pkgs.dockerTools.buildImage {
    name = "oci-ca-bundle";
    tag = "0.0.1";

    contents = [
      caBundle

    ];
}
