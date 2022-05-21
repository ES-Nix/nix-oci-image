#!/usr/bin/env sh



# TODO: repeat this if every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
echo ${is_local}

if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  echo 'A'
  nix build --refresh .#oci-nix
  podman load < result
else
    echo 'B'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix
  podman load < result
fi

podman \
build \
--file Containerfile \
--tag nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
.

