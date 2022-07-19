#
# nix build .#oci-hello
# podman load < result
# podman run localhost/hello-world:0.0.1
{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildImage {
  name = "hello-world";
  tag = "0.0.1";

  config = {
    Cmd = [ "${pkgs.pkgsStatic.hello}/bin/hello" ];
  };
}
