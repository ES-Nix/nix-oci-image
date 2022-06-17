#!/usr/bin/env bash



# TODO: adds some logic that allow not passing any args
#  and it defaults to current directory.

./fmt-nix-fix.sh

./fmt-nix-check.sh '.'

exit 0
