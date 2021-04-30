{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
      name = "tmp";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir -p $out/tmp
        mkdir -p $out/home/nixuser/tmp
      '';
    }
