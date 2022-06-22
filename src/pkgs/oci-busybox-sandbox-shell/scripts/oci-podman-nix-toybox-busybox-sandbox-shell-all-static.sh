#!/usr/bin/env bash


ATTRIBUTE_NIX='oci-nix-toybox-busybox-sandbox-shell-all-static'
if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  echo 'Locally building'
  nix build --refresh .#"${ATTRIBUTE_NIX}" \
  && podman load < result
else
  echo 'Remote building'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#"${ATTRIBUTE_NIX}" \
  && podman load < result
fi

#podman \
#build \
#--file Containerfile \
#--tag busybox-sandbox-shell \
#--target test-busybox-sandbox-shell \
#.

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
localhost/"${ATTRIBUTE_NIX}":0.0.1

# mkdir -m1777 /tmp
# nix --extra-experimental-features 'nix-command flakes' flake metadata nixpkgs
# nix --extra-experimental-features 'nix-command flakes' run --refresh github:ES-Nix/nix-qemu-kvm/dev

# --userns=host \