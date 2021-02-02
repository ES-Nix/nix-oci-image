#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix-env --file "<nixpkgs>" --install --attr \
commonsCompress \
gnutar \
lzma.bin \
git

nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'

