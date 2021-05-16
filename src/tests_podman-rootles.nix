{ pkgs ? import <nixpkgs> { }, podman-rootless }:
pkgs.runCommand "tests_podman-rootles-run-command"
{ buildInputs = with pkgs; [ podman-rootless hello file ]; }
  ''
    # https://github.com/NixOS/nix/issues/670
    mkdir --parent $out/home/podmanrootlessuser
    export HOME=$out/home/podmanrootlessuser

    podman --version > $out/podman_version.txt
    podman images
  ''
