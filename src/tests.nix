{ pkgs ? import <nixpkgs> { } }:
rec {

  tests = import ./tests/tests.nix {
    pkgs = pkgs;
  };
}
