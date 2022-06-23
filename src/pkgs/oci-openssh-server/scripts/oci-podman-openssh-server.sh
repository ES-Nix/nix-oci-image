#!/usr/bin/env sh

podman \
build \
--file Containerfile \
--tag=oci-ubuntu-16-04-with-sshd-and-nixuser \
.


# xhost +

test -d "${HOME}"/.ssh || mkdir -pv "${HOME}"/.ssh
test -f "${HOME}"/.ssh/known_hosts || touch "${HOME}"/.ssh/known_hosts

podman \
run \
--detach=true \
--device=/dev/fuse \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/usr/bin:/bin \
--env=STORAGE_DRIVER='vfs' \
--hostname=oci-ubuntu-16-04-container \
--interactive=true \
--log-level=error \
--mount=type=tmpfs,destination=/var/lib/containers \
--name=ubuntu-16-04-container \
--privileged=true \
--publish=22000:22 \
--rm=true \
--security-opt label=disable \
--security-opt seccomp=unconfined \
--tty=true \
--user=root \
--volume="$(pwd)":/home/nixuser/code:rw \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--workdir=/home/nixuser \
localhost/oci-ubuntu-16-04-with-sshd-and-nixuser:latest

while ! nc -t -w 1 -z localhost 22000; do echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done \
&& ssh-keygen -R '[localhost]:22000' \
&& ssh \
    nixuser@localhost \
    -p 22000 \
    -o StrictHostKeyChecking=no \
    -o StrictHostKeyChecking=accept-new


#podman \
#rm \
#--force \
#--ignore \
#ubuntu-16-04-container

#podman \
#run \
#--privileged \
#--net=host \
#--rm \
#quay.io/podman/stable \
#podman \
#run \
#--net=host \
#--storage-driver=vfs \
#docker.io/library/ubuntu:22.04 \
#bash \
#-c \
#'apt-get update'


#podman \
#run \
#--privileged \
#--net=host \
#--rm \
#quay.io/podman/stable \
#  podman \
#    run \
#    --net=host \
#    --storage-driver=vfs \
#    docker.io/library/ubuntu:16.04

# xhost -
