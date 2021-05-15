{ pkgs ? import <nixpkgs> { }, podman-rootless }:
pkgs.runCommand "tests_podman-rootles-run-command"
{ buildInputs = with pkgs; [ podman-rootless hello file ]; }
  ''
    mkdir --parent $out/home/podmanrootlessuser
    export HOME=$out/home/podmanrootlessuser

    podman --version > $out/podman_version.txt
    # podman images
  ''
