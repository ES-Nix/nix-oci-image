#!/usr/bin/env sh



TOYBOX_PATH='/home/nixuser/bin/toybox'
TOYBOX_VOLUME='volume_toybox'
ALPINE='docker.io/library/alpine:3.13.5'
MINIMAL_OCI='localhost/empty-image-zero-size:0.0.1'



nix build ../../#empty

podman load < result


podman volume rm --force "$TOYBOX_VOLUME"
podman volume create "$TOYBOX_VOLUME"
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/code \
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

mkdir -p /code/nixuser/bin
cp /toybox/root/host/fs/bin/toybox /code/nixuser/bin
chmod 0755 /code/nixuser/bin/toybox

COMMANDS

podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
"$ALPINE" \
sh \
-c '."$TOYBOX_PATH" id'


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
"$MINIMAL_OCI"  \
."$TOYBOX_PATH" id


podman \
run \
--entrypoint="$TOYBOX_PATH" \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
"$MINIMAL_OCI"  \
id


podman volume rm --force volume_nix_static
podman volume create volume_nix_static

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_nix_static:/code \
--user='0' \
"$ALPINE" \
sh \
<< COMMAND
apk update
apk add --no-cache curl
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix
sha256sum nix
chmod +x ./nix
cp nix /code/nix
COMMAND


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":"$TOYBOX_PATH":ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
"$ALPINE" \
sh \
-c \
'/code/nix --version'


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":"$TOYBOX_PATH":ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
"$MINIMAL_OCI"  \
/code/nix --version


podman \
run \
--entrypoint="$TOYBOX_PATH" \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
"$MINIMAL_OCI"  \
sh \
-c \
'/code/nix --version'

podman volume rm --force volume_etc
podman volume create volume_etc
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_etc:/code \
--user='0' \
"$ALPINE" \
sh \
<< COMMAND
mkdir -p /code/ssl/certs/
cp -r /etc/ssl/certs/ /code/ssl/
COMMAND


podman \
run \
--entrypoint="$TOYBOX_PATH" \
--env='USER=nixuser' \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/home:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
"$MINIMAL_OCI"  \
sh \
-c \
"/code/nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay && ./result/bin/cowsay 'Hi!'"



#CONTAINER='foo'
#podman \
#run \
#--env=USER=nixuser \
#--interactive=true \
#--name="$CONTAINER" \
#--tty=true \
#--rm=false \
#--user='0' \
#--volume="$TOYBOX_VOLUME":/home:ro \
#--volume=volume_nix_static:/code:ro \
#--volume=volume_tmp:/tmp/:rw \
#localhost/nix_wip:0.0.1  \
#"$TOYBOX_PATH" sh -c id
#
#podman start --interactive=true "$CONTAINER"
#
#"$TOYBOX_PATH" mkdir -p /home/nixuser
#echo 'nixuser:x:12345:6789::/home/nixuser:/home/bin/toybox' > /etc/passwd
#echo 'nixgroup:x:6789:' > /etc/group
#
#/home/bin/toybox chown nixuser:nixgroup /home/nixuser
#
#/home/bin/toybox chown nixuser:nixgroup -R /home/nixuser
#/home/bin/toybox chmod 0755 -R /home/nixuser/
#/home/bin/toybox chmod 0700 /home/nixuser
#
#/home/bin/toybox chown nixuser:nixgroup /home/bin/toybox
#
#
#podman rm --force --ignore "$CONTAINER"
#
##\
##-c \
##"/code/nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay && ./result/bin/cowsay 'Hi!'"
#0755