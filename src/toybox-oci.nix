{ pkgs ? import <nixpkgs> { } }:
let
  toybox = import ./toybox.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "toybox-oci";
  tag = "0.0.1";

  contents = [
    toybox
  ];

  config = {
    Cmd = [ "/bin/toybox" ];
  };
}
