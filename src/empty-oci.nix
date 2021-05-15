{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildImage {
  name = "empty";
  tag = "0.0.1";
}
