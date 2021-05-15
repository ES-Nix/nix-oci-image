{ pkgs ? import <nixpkgs> { } }:
let
  toybox = pkgs.fetchurl {
    url = "http://landley.net/toybox/downloads/binaries/0.8.4/toybox-x86_64";
    hash = "sha256-l5f9aXpxPCbelv61bY9zsPd3okzfqCZ+khlbl+isAOA=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "toybox-static";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir --parent $out/home/nixuser/bin
    cp ${toybox} $out/home/nixuser/bin/toybox
    chmod +x $out/home/nixuser/bin/toybox
  '';
}
