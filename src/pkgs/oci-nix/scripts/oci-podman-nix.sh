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
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--publish=22000:22 \
--tty=true \
--rm=true \
--user=nixuser \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
--workdir=/home/nixuser \
localhost/nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su:latest

#podman \
#run \
#--group-add=keep-groups \
#--device=/dev/kvm \
#--hostname=ubuntu-container \
#--privileged=true \
#--userns=keep-id \
#--tty=true \
#--interactive=true \
#--rm=true \
#--volume="$(pwd)":"${HOME}/code" \
#--volume="${HOME}/.ssh":"${HOME}/.ssh" \
#--workdir="${HOME}" \
#docker.io/library/ubuntu:20.04 \
# bash \
#-c \
#'ls -la "${HOME}"/code'

#sudo /bin/sshd -D -e -ddd

# --user=root \
# --network=host \
# --userns=host \
# --volume="${HOME}"/.ssh/id_rsa:/home/nixuser/.ssh/id_rsa:ro \


xhost -

# sudo mkdir /var/empty
# sudo ssh-keygen -A
# sudo /bin/sshd -D