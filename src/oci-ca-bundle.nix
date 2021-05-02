{ pkgs ? import <nixpkgs> { } }:
let
  ca-bundle = import ./ca-bundle.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
    name = "oci-ca-bundle";
    tag = "0.0.1";

    contents = [
      ca-bundle
    ];
}
