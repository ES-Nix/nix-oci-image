{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildImage {
    name = "empty-image-zero-size";
    tag = "0.0.1";
}
