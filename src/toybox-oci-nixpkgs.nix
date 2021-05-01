{ pkgs ? import <nixpkgs> { } }:

pkgs.dockerTools.buildImage {
  name = "toybox-oci";
  tag = "0.0.1";

  contents = [
    pkgs.toybox
  ];

  config = {
    Cmd = [ "toybox" ];
  };
}

