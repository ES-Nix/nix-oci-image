#!/usr/bin/env sh


nix build ../../#empty

podman load < result


podman volume rm --force volume_toybox
podman volume create volume_toybox
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume=volume_toybox:/code \
docker.io/library/alpine:3.13.5 \
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
--volume=volume_toybox:/home:ro \
docker.io/library/alpine:3.13.5 \
sh \
-c './home/nixuser/bin/toybox id'


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home:ro \
localhost/empty-image-zero-size:0.0.1  \
./home/nixuser/bin/toybox id


podman \
run \
--entrypoint=/home/nixuser/bin/toybox \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home:ro \
localhost/empty-image-zero-size:0.0.1  \
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
docker.io/library/alpine:3.13.5 \
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
--volume=volume_toybox:/home/nixuser/bin/toybox:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
docker.io/library/alpine:3.13.5 \
sh \
-c \
'/code/nix --version'


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home/nixuser/bin/toybox:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
localhost/empty-image-zero-size:0.0.1  \
/code/nix --version


podman \
run \
--entrypoint=/home/nixuser/bin/toybox \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
localhost/empty-image-zero-size:0.0.1  \
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
docker.io/library/alpine:3.13.5 \
sh \
<< COMMAND
mkdir -p /code/ssl/certs/
cp -r /etc/ssl/certs/ /code/ssl/
COMMAND


podman \
run \
--entrypoint=/home/nixuser/bin/toybox \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
localhost/empty-image-zero-size:0.0.1  \
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
#--volume=volume_toybox:/home:ro \
#--volume=volume_nix_static:/code:ro \
#--volume=volume_tmp:/tmp/:rw \
#localhost/nix_wip:0.0.1  \
#/home/nixuser/bin/toybox sh -c id
#
#podman start --interactive=true "$CONTAINER"
#
#/home/nixuser/bin/toybox mkdir -p /home/nixuser
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