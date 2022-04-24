{ pkgs ? import <nixpkgs> { } }:
let

  # It will brake the sha256
#   nix = pkgs.fetchurl {
#    url = "https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist";
#    hash = "sha256-0000000000000000000000000000000000000000000=";
#   };


# Got to find the id https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux
  nix = pkgs.fetchurl {
    url = "https://hydra.nixos.org/build/172820610/download/2/nix";
    hash = "sha256-dO9LLY/1BX4pRvg1vj8gxdKPyxyyM05QoRmEiv+GWFs=";
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
