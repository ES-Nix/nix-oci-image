#!/usr/bin/env bash

echo '@@@@'

# TODO: repeat this if every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
if [[ ${is_local} ]]; then
  echo 'Locally building'
  nix build --refresh .#oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp \
  && podman load < result
else
  echo 'Remote building'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp \
  && podman load < result
fi

podman \
build \
--file Containerfile \
--tag nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp \
--target test-nix \
.

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
localhost/nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:latest
