{ pkgs ? import <nixpkgs> { } }:
let
    nix = pkgs.fetchurl {
        url = "https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist";
        hash = "sha256-lIOQnw8tLkcy3ng9O+7vAtYReQ/w5fg0u0qKmLDsqtQ=";
    };
in
   nix