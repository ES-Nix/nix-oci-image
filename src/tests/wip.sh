#!/usr/bin/env sh



TOYBOX_PATH='/home/nixuser/bin/toybox'
TOYBOX_VOLUME='volume_toybox'
ALPINE='docker.io/library/alpine:3.13.5'
MINIMAL_OCI='localhost/empty-image-zero-size:0.0.1'
WIP_OCI='localhost/nix_wip:0.0.1'



nix build ../../#wip

podman load < result


podman volume rm --force "$TOYBOX_VOLUME"
podman volume create "$TOYBOX_VOLUME"
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home \
"$ALPINE" \
sh \
<< COMMANDS

apk update

apk \
add \
--no-cache \
bash \
gcc \
linux-headers \
make \
musl-dev

mkdir /toybox
cd /toybox

wget  -O toybox.tgz "https://landley.net/toybox/downloads/toybox-0.8.4.tar.gz"
tar -xf toybox.tgz --strip-components=1
rm toybox.tgz
make root BUILTIN=1

mkdir -p /home/nixuser/bin
cp /toybox/root/host/fs/bin/toybox /home/nixuser/bin
chmod 0755 /home/nixuser/bin/toybox
COMMANDS

CONTAINER='foo'
podman \
run \
--env=USER=nixuser \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
--volume=volume_tmp:/tmp/:rw \
"$WIP_OCI"  \
"$TOYBOX_PATH" \
sh \
<< COMMANDS
./home/nixuser/bin/toybox ls
COMMANDS