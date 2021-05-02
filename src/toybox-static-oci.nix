{ pkgs ? import <nixpkgs> { } }:
let
  toybox-static = import ./toybox-static.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "toybox-static-oci";
  tag = "0.0.1";

  contents = [
    toybox-static
  ];

  config = {
    Cmd = [ "/bin/toybox" ];
  };
}
