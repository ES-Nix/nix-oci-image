#!/usr/bin/env bash



# TODO: repeat this if every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
if [[ ${is_local} ]]; then
  echo 'Locally building'
  nix build --refresh .#oci-empty \
  && podman load < result
else
  echo 'Remote building'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-empty \
  && podman load < result
fi

podman \
build \
--file Containerfile \
--tag busybox-sandbox-shell \
--target oci-busybox-sandbox-shell \
.

podman images
