#!/usr/bin/env sh



# TODO: repeat this if every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
echo ${is_local}

if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  echo 'A'
  nix build --refresh .#oci-nix-sudo-su
  podman load < result
else
    echo 'B'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix-sudo-su
  podman load < result
fi

#podman \
#build \
#--file Containerfile \
#--tag nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
#--target test-nix \
#.


command -v xhost 1> /dev/null 2> /dev/null && xhost +

test -d /tmp || ( echo 'The system does not have /tmp' && exit 123 )
test -f /tmp/.X11-unix || touch /tmp/.X11-unix

# --volume="${HOME}/.ssh":"${HOME}/.ssh":ro \
# --publish=12345:22 \
podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/mnt/nixuser/code:rw \
--workdir=/home/nixuser \
localhost/nix-sudo-su:0.0.1 \
"$@"

#podman \
#run \
#--device /deve/kvm \
#--privileged \
#--userns keep-id \
#-it \
#--rm \
#-v "$(pwd)":"${HOME}/code" \
#-v "${HOME}/.ssh":"${HOME}/.ssh" \
#-w "${HOME}" \
#ubuntu:20.04

#sudo /bin/sshd -D -e -ddd

# --user=root \
# --network=host \
# --userns=host \
# --volume="${HOME}"/.ssh/id_rsa:/home/nixuser/.ssh/id_rsa:ro \
command -v xhost 1> /dev/null 2> /dev/null && xhost -

# sudo mkdir /var/empty
# sudo ssh-keygen -A
# sudo /bin/sshd -D