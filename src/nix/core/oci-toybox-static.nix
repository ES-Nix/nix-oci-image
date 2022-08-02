{ pkgs ? import <nixpkgs> { } }:
let
  toybox-etc-passwd-etc-group = import ./toybox-etc-passwd-etc-group.nix { inherit pkgs; };
  #  tmp = import ./create-tmp.nix { inherit pkgs; };
  toybox-static = import ./toybox-static.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "oci-toybox-static";
  tag = "0.0.1";

  contents = [
    toybox-etc-passwd-etc-group
    #    tmp
    toybox-static
  ]
  ++
  (with pkgs; [
    #    busybox-sandbox-shell
    #    coreutils
  ]);

  config = {
    Cmd = [ "sh" ];
    Entrypoint = [ "${toybox-static}/bin/toybox" ];
    Env = [
      "USER=guest"
      "HOME=/home/guest"
    ];
  };
}
