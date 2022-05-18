#!/usr/bin/env sh



# TODO: repeat this if every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
if [[ ${is_local} ]]; then
  nix build --refresh .#oci-nix
  podman load < result
else
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix
  podman load < result
fi

podman \
build \
--file Containerfile \
--tag nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
--target test-nix \
.


xhost +

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
--user=nixuser \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
localhost/nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su:latest

# --volume="${HOME}"/.ssh/id_rsa:/home/nixuser/.ssh/id_rsa:ro \ 
xhost -
