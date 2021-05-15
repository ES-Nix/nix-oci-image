{ pkgs ? import <nixpkgs> { } }:
pkgs.runCommand "build-with-dependency"
{ buildInputs = [ pkgs.python3Minimal ]; }
  ''
    mkdir $out

    python --version > $out/python
    cp -r ${./tests} $out/tests
    cd $out/tests
    python -m unittest

  ''
