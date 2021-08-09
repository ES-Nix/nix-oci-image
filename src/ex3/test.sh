#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

nix build .#busybox-sandbox-shell-nix-flakes \
&& podman load < result \


nix build .#empty \
&& podman load < result \

podman \
build \
--file=ex3/Containerfile \
--tag=busybox-sandbox-shell-nix-flake-patch \
--target=busybox-sandbox-shell-nix-flake-patch


podman \
build \
--file=ex3/Containerfile \
--tag=nix \
--target=nix


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=nixuser \
--privileged=true \
localhost/nix:latest \
sh \
-c \
'. ~/.fix-env && nix shell nixpkgs#bash nixpkgs#hello --command hello'

#podman \
#run \
#--interactive=true \
#--tty=true \
#--rm=true \
#--user=guest \
#--privileged=true \
#localhost/toybox-nix:latest \
#sh \
#-c \
#'. ~/.fix-env && nix shell nixpkgs#bash nixpkgs#hello --command hello'

#\
#-c 'nix shell nixpkgs#bash nixpkgs#hello --command hello'

#nix shell nixpkgs#bash nixpkgs#coreutils --command id

#nix \
#profile \
#install \
#github:ES-Nix/podman-rootless/from-nixpkgs
