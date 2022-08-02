{ pkgs ? import <nixpkgs> { } }:
# For some reason buildLayeredImage yields
# a bigger image than buildImage.
pkgs.dockerTools.buildLayeredImage {
  name = "oci-empty-image";
  tag = "0.0.1";
}
