#!/usr/bin/env sh


find . -type f -iname '*.nix' -exec nixpkgs-fmt {} \;

exit 0
