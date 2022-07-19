#!/usr/bin/env sh



# Is it a bad thing? I think in small cases it would be useful.
build-and-load-oci-podman-nix 'github:ES-Nix/nix-oci-image/nix-static-minimal' 'oci-nix' 'nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su'


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
