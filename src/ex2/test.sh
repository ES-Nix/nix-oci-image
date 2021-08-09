#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

podman \
build \
--file=Containerfile \
--tag=toybox-nix \
--target=toybox-nix

#podman \
#run \
#--interactive=true \
#--tty=true \
#--rm=true \
#--user=0 \
#localhost/busybox-sandbox-shell-nix-flake-patch:latest \
#-c 'nix shell nixpkgs#bash nixpkgs#hello --command hello'

podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=guest \
--privileged=true \
localhost/toybox-nix:latest \
sh \
-c \
'. ~/.fix-env && nix shell nixpkgs#bash nixpkgs#hello --command hello'

#\
#-c 'nix shell nixpkgs#bash nixpkgs#hello --command hello'

#nix shell nixpkgs#bash nixpkgs#coreutils --command id

#nix \
#profile \
#install \
#github:ES-Nix/podman-rootless/from-nixpkgs
