#!/usr/bin/env sh



if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  echo 'A'
  nix build --refresh .#oci-nix-entrypoint
else
    echo 'B'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix-entrypoint
fi

podman load < result


podman \
build \
--file Containerfile \
--tag test-nix-entrypoint \
--target test-nix-entrypoint \
.


podman \
build \
--file Containerfile \
--tag test-nix-entrypoint-with-iso \
--target with-iso \
.

xhost +

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env="UID_FOR_CONTAINER=$(id -u)" \
--env="GID_FOR_CONTAINER=$(id -g)" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--publish=12345:22 \
--tty=true \
--rm=true \
--user=root \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
--workdir=/home/nixuser \
localhost/test-nix-entrypoint:latest

#sudo /bin/sshd -D -e -ddd


# --storage-driver="vfs" \
# --cgroups=disabled \
# --network=host \
# --userns=host \
# --volume="${HOME}"/.ssh/id_rsa:/home/nixuser/.ssh/id_rsa:ro \
xhost -

# sudo mkdir /var/empty
# sudo ssh-keygen -A
# sudo /bin/sshd -D