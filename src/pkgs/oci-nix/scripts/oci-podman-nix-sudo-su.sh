#!/usr/bin/env sh



# TODO: repeat this 'if' every where is bad, not dry
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
# echo ${is_local}

if nix flake metadata .# 1> /dev/null 2> /dev/null; then
  # touch file $(readlink -f result) | cut -d':' -f1
  # echo 'A'
  nix build --refresh .#oci-nix-sudo-su
  podman load < result
else
  # echo 'B'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-nix-sudo-su
  podman load < result
fi

#podman \
#build \
#--file Containerfile \
#--tag nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
#--target test-nix \
#.

echo

# TODO:
nix run nixpkgs#xorg.xhost -- +
# command -v xhost 1> /dev/null 2> /dev/null && xhost +

# TODO:
# test -d /tmp || ( echo 'The system does not have /tmp' && exit 123 )
test -f /tmp/.X11-unix || touch /tmp/.X11-unix

# podman unshare chown 1234:6789 "$(pwd)"

#subuidSize=$(( $(podman info --format "{{ range .Host.IDMappings.UIDMap }}+{{.Size }}{{end }}" ) - 1 ))
#subgidSize=$(( $(podman info --format "{{ range .Host.IDMappings.GIDMap }}+{{.Size }}{{end }}" ) - 1 ))
#
## NixOS has this variables as readonly!
#[ -n "$UID" ] && echo "The UID is not empty, its value is: UID=$UID" || UID="$(id -u)"
#[ -n "$GID" ] && echo "The GID is not empty, its value is: GID=$GID" || GID="$(id -g)"


# --volume="${HOME}/.ssh":"${HOME}/.ssh":ro \
# --publish=12345:22 \
#--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
#--volume=/etc/localtime:/etc/localtime:ro \
#--volume=/dev/shm:/dev/shm:ro \
#--volume=/dev/snd:/dev/snd:ro \
# --volume="$(pwd)":/home/nixuser/code:rw \
#podman \
#run \
#--device=/dev/kvm \
#--device=/dev/fuse \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--env="INJECTED_UID=${UID}" \
#--env=:"INJECTED_GID=${GID}" \
#--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
#--interactive=true \
#--mount=type=tmpfs,destination=/var/lib/containers \
#--privileged=true \
#--tty=true \
#--rm=true \
#--security-opt "label=disable" \
#--user "${UID}":"${GID}" \
#--uidmap "${UID}":0:1 \
#--uidmap 0:1:"${UID}" \
#--uidmap $(("${UID}"+1)):$(("${UID}"+1)):$(($subuidSize-"${UID}")) \
#--gidmap "${GID}":0:1 \
#--gidmap 0:1:"${GID}" \
#--gidmap $(("${GID}"+1)):$(("${GID}"+1)):$(($subgidSize-"${GID}")) \
#--workdir=/home/nixuser \
#localhost/nix-sudo-su:0.0.1 \
#"$@"


#podman \
#run \
#--device=/dev/kvm \
#--device=/dev/fuse \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
#--group-add=keep-groups \
#--interactive=true \
#--mount=type=tmpfs,destination=/var/lib/containers \
#--privileged=true \
#--tty=true \
#--rm=true \
#--security-opt "label=disable" \
#--user "${UID}":"${GID}" \
#--userns=keep-id \
#--workdir=/home/nixuser \
#localhost/nix-sudo-su:0.0.1 \
#"$@"


# To clean all state
# chown $(id -u):$(id -g) -R data
# rm -fr data
test -d data || mkdir -pv data/tmp

# It pays of its ugliness
test -f data/.config/nix/nix.conf || {
  mkdir -pv data/.config/nix && echo 'experimental-features = nix-command flakes' > data/.config/nix/nix.conf
}

podman \
run \
--annotation=run.oci.keep_original_groups=1 \
--device=/dev/fuse:rw \
--device=/dev/kvm:rw \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env="HOME=${HOME:-:/home/someuser}" \
--env="PATH=/bin:$HOME/.nix-profile/bin" \
--env="TMPDIR=${HOME}" \
--env="USER=${USER:-:someuser}" \
--group-add=keep-groups \
--hostname=container-nix \
--interactive=true \
--name=conteiner-unprivileged-nix \
--privileged=true \
--tty=true \
--userns=keep-id \
--rm=true \
--volume="$(pwd)"/data:"$HOME":U \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--workdir="$HOME" \
localhost/nix-sudo-su:0.0.1 \
"$@"

#sh \
#-c \
#'
#id
#echo
#
#groups
#echo
#
#echo abcdefg > foo.txt
#stat -c %u .
#stat -c %u /home/"${USER}"
#' \
#&& stat -c %u data/foo.txt

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