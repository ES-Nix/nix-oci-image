#!/usr/bin/env bash


./fmt-nix-fix.sh

./fmt-nix-check.sh "$@"

exit 0
