{ pkgs ? import <nixpkgs> { } }:
let
  nix-static-bare = import ./nix.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "nix-static-bare";
  tag = "0.0.1";

  contents = [
    nix-static-bare
  ];
}
