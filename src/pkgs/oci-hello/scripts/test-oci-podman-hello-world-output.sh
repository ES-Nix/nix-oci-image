#!/usr/bin/env sh

IMAGE_NAME='test-podman-hello-world-output.nix'

# Is it a bad thing? I think in small cases it would be useful.
build-and-load-oci-podman-nix 'github:ES-Nix/nix-oci-image/nix-static-minimal' 'oci-hello' "${IMAGE_NAME}"

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--publish=22000:22 \
--tty=false \
--rm=true \
--user=nixuser \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
--workdir=/home/nixuser \
localhost/"${IMAGE_NAME}":latest
