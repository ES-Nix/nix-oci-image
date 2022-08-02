{ pkgs ? import <nixpkgs> { } }:
let
  toybox = pkgs.fetchurl {
    url = "http://landley.net/toybox/downloads/binaries/0.8.5/toybox-x86_64";
    hash = "sha256-hj2ljFlg5Wwf2t5gHJ70mq3z4E+RTO34QcXn9XdlvMw=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "toybox-static";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir --parent $out/bin
    cp ${toybox} $out/bin/toybox
    chmod +x $out/bin/toybox
  '';
}
