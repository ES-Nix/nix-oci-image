#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix build .#oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
&& docker load < result


docker \
build \
--file src/ex9/Containerfile \
--tag test-nix \
--target test-nix \
./src/ex9

# ./src/ex9/build_load_and_commit.sh

docker images

#docker create --name nix-volume-container --volume /nix-volume alpine sh
#
#docker \
#run \
#--log-level=error \
#--privileged=false \
#--device=/dev/fuse \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--mount=type=volume,source=nix-volume,target=/nix-volume \
#--network=host \
#--tty=false \
#--rm=true \
#--user=0 \
#localhost/nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
#<<COMMANDS
#cp \
#  --no-dereference \
#  --verbose \
#  /bin/nix \
#  /nix-volume
#COMMANDS




xhost + \
&& docker \
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
test-nix:latest \
&& xhost -

#xhost + \
#&& { docker \
#run \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
#--volume=/etc/localtime:/etc/localtime:ro \
#localhost/test-nix:latest \
#<< COMMANDS
#
#echo 'Started nix shell...'
#
#nix \
#shell \
#nixpkgs#xorg.xclock \
#nixpkgs#coreutils --command timeout 10 xclock || test $? -eq 124 || echo 'Error'
#
#echo 'End nix shell.'
#
#COMMANDS
#} && xhost -

