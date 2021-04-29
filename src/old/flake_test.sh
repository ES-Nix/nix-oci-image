#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix-env --file "<nixpkgs>" --install --attr \
commonsCompress \
gnutar \
lzma.bin \
git

echo 'system-features = kvm nixos-test' >> ~/.config/nix/nix.conf

echo 'experimental-features = nix-command flakes ca-references' >> ~/.config/nix/nix.conf

nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'

