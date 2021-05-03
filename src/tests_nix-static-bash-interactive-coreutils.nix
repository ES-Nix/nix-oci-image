{ pkgs ? import <nixpkgs> { } }:
pkgs.runCommand "tests_nix-static-bash-interactive-coreutils"
{ buildInputs = with pkgs; [ python3Minimal ]; }
 ''
  mkdir $out
  cp -r ${./tests} $out/tests
  cd $out/tests
  python -m unittest tests_nix-static-bash-interactive-coreutils.py
''
