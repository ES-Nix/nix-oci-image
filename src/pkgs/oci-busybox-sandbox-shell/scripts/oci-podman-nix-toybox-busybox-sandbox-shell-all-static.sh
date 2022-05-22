#!/usr/bin/env bash



if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  echo 'Locally building'
  nix build --refresh .#oci-nix-toybox-busybox-sandbox-shell-all-static \
  && podman load < result
else
  echo 'Remote building'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix-toybox-busybox-sandbox-shell-all-static \
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
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
localhost/static-nix-busybox-static-sandbox-shell:0.0.1

# mkdir -m1777 /tmp
# nix --extra-experimental-features 'nix-command flakes' flake metadata nixpkgs
# nix --extra-experimental-features 'nix-command flakes' run --refresh github:ES-Nix/nix-qemu-kvm/dev

# --userns=host \