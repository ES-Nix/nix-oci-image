#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail

nix build .#busybox-sandbox-shell-nix-flakes \
&& podman load < result \
&& podman \
build \
--file=Containerfile \
--tag=busybox-sandbox-shell-nix-flake-patch \
--target=busybox-sandbox-shell-nix-flake-patch

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
--env=USER=nixuser \
--env=HOME=/home/nixuser \
--env=TMPDIR=/home/nixuser/tmp \
--interactive=true \
--tty=true \
--rm=true \
--user=nixuser \
--privileged=true \
localhost/busybox-sandbox-shell-nix-flake-patch:latest \
-c 'nix shell nixpkgs#bash nixpkgs#hello --command hello'

#nix shell nixpkgs#bash nixpkgs#coreutils --command id

#nix \
#profile \
#install \
#github:ES-Nix/podman-rootless/from-nixpkgs
