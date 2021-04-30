{ pkgs ? import <nixpkgs> { } }:
let
  nix = pkgs.fetchurl {
    url = "https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist";
    hash = "sha256-8OnU2GUMzvmzQFa0RahI8jU9Jd3+PU+nBGxjdoQfVPs=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "nix-static";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir --parent $out/bin
    cp ${nix} $out/bin/nix
    chmod +x $out/bin/nix
  '';
}
