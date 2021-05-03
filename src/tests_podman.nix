{ pkgs ? import <nixpkgs> { } , podman }:
pkgs.runCommand "tests_nix-static-bash-interactive-coreutils"
{ buildInputs = with pkgs; [ python3Minimal (podman) hello ]; }
 ''
  mkdir $out
  cp -r ${./tests} $out/tests
  cd $out/tests
  python -m unittest tests_podman.py
''
