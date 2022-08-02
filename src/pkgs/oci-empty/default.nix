{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildImage {
  name = "empty";
}
