{ pkgs ? import <nixpkgs> { } }:
let

  # It will brake the sha256
  # nixLatest = pkgs.fetchurl {
  #  url = "https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist";
  #  hash = "sha256-PbeMzxYQ5+YeKaAm0nMB4E0b7qHBpdf2DKHGFSI1Rms=";
  # };

  nix = pkgs.fetchurl {
    url = "https://hydra.nixos.org/build/144116239/download/2/nix";
    hash = "sha256-5ivieDwrj1tgrqvOtQ8NdVfoyfw3Ytv11+CQ44NuKqw=";
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
