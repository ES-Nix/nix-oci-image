#!/usr/bin/env sh



TOYBOX_PATH='./root/toybox'
TOYBOX_VOLUME='volume_toybox'
ALPINE='docker.io/library/alpine:3.13.5'
MINIMAL_OCI='localhost/empty-image-zero-size:0.0.1'
WIP_OCI='localhost/nix_wip:0.0.1'
CONTAINER='foo'
NIX_IMAGE='nix'



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
--volume="$TOYBOX_VOLUME":/root \
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


cp /toybox/root/host/fs/bin/toybox /root
chmod 0755 /root/toybox
COMMANDS


podman \
run \
--env=USER=nixuser \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/root:ro \
--volume=volume_tmp:/tmp/:rw \
"$WIP_OCI" \
"$TOYBOX_PATH" \
sh \
<< COMMANDS
./root/toybox ls
COMMANDS

podman \
run \
--env=USER=nixuser \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user='0' \
--volume="$TOYBOX_VOLUME":/root:ro \
"$WIP_OCI" \
"$TOYBOX_PATH" \
sh \
<< COMMANDS

/root/toybox cp /root/toybox /home/nixuser/bin

./home/nixuser/bin/toybox mkdir /nix
./home/nixuser/bin/toybox chmod 0755 -R /home/nixuser/
./home/nixuser/bin/toybox chmod 0700 /home/nixuser
./home/nixuser/bin/toybox chmod 1777 /tmp
./home/nixuser/bin/toybox chown nixuser:nixgroup -R /home/nixuser /nix
#./home/nixuser/bin/toybox chmod 0700 /root /etc
COMMANDS


rm -f oci_diff.txt
podman diff "$CONTAINER" > oci_diff.txt

ID=$(
  podman \
  commit \
  "$CONTAINER" \
  "$NIX_IMAGE"
)

podman rm --force --ignore "$CONTAINER"


podman \
run \
--env=USER=nixuser \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='0' \
--volume="$TOYBOX_VOLUME":/root:ro \
"$NIX_IMAGE"  \
"$TOYBOX_PATH" \
sh \
<< COMMANDS
./home/nixuser/bin/toybox id
COMMANDS

podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
--volume="$TOYBOX_VOLUME":/root:ro \
"$NIX_IMAGE"  \
"$TOYBOX_PATH" \
sh \
<< COMMANDS
./home/nixuser/bin/toybox id
COMMANDS


podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
"$NIX_IMAGE"  \
toybox \
sh \
<< COMMANDS
./home/nixuser/bin/toybox id
COMMANDS


podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
"$NIX_IMAGE"  \
toybox \
sh \
<< COMMANDS
toybox id
COMMANDS



podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
"$NIX_IMAGE" \
toybox \
sh \
<< COMMANDS
echo "Building cowsay"
nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay

/nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

toybox ls -ahl result
toybox file result

toybox rm -fr result
echo "nix store gc"
nix --experimental-features 'nix-command ca-references flakes' store gc

#/nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

COMMANDS



podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
"$NIX_IMAGE" \
toybox \
sh \
<< COMMANDS
echo "Building cowsay"
nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay

/nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

toybox ls -ahl result
toybox file result

echo "nix shell nixpkgs#bashInteractive nixpkgs#coreutils"
nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#bashInteractive nixpkgs#coreutils --command bash -c "./result/bin/cowsay Hi!"

toybox rm -fr result
echo "nix store gc"
nix --experimental-features 'nix-command ca-references flakes' store gc

#/nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

COMMANDS


#podman \
#run \
#--interactive=true \
#--name="$CONTAINER" \
#--tty=true \
#--rm=true \
#--user='nixuser' \
#--workdir=/home/nixuser \
#"$NIX_IMAGE" \
#nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#bashInteractive nixpkgs#coreutils --command bash

#podman \
#run \
#--env=USER=nixuser \
#--interactive=true \
#--tty=true \
#--rm=true \
#--user='nixuser' \
#--volume="$TOYBOX_VOLUME":/home:rw \
#--volume=volume_tmp:/tmp/:rw \
#--workdir=/home/nixuser \
#"$NIX_IMAGE"  \
#"$TOYBOX_PATH" \
#sh
#nix --experimental-features 'nix-command ca-references flakes' --store /home/nixuser store gc
#nix --experimental-features 'nix-command ca-references flakes' --store /home/nixuser build nixpkgs#cowsay
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay

#podman \
#run \
#--env=USER=nixuser \
#--interactive=true \
#--tty=false \
#--rm=true \
#--user='nixuser' \
#--volume="$TOYBOX_VOLUME":/home:rw \
#--workdir=/home/nixuser \
#"$NIX_IMAGE"  \
#"$TOYBOX_PATH" \
#sh \
#<< COMMANDS
#
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay --out-link cowsay
#cowsay/bin/cowsay "Hi!"
#
#cowsay/bin/cowsay "nix store gc"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#cowsay/bin/cowsay "gcc"
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#gcc
#
#./home/nixuser/bin/toybox rm -f result
#cowsay/bin/cowsay "nix store gc"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#cowsay/bin/cowsay "python39"
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#python39
#
#./home/nixuser/bin/toybox rm -f result
#cowsay/bin/cowsay "nix store gc"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#cowsay/bin/cowsay "qemu"
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#qemu
#
#./home/nixuser/bin/toybox rm -f result
#cowsay/bin/cowsay "qgis"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#qgis
#
#./home/nixuser/bin/toybox rm -f result
#cowsay/bin/cowsay "blender"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#blender
#
#
#cowsay/bin/cowsay "x11"
#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#x11
#
#./home/nixuser/bin/toybox rm -f result
#cowsay/bin/cowsay "nix store gc"
#nix --experimental-features 'nix-command ca-references flakes' store gc
#
#COMMANDS


#podman \
#run \
#--env=USER=nixuser \
#--interactive=true \
#--tty=true \
#--rm=true \
#--user='nixuser' \
#--volume="$TOYBOX_VOLUME":/home:rw \
#--workdir=/home/nixuser \
#"$NIX_IMAGE"  \
#"$TOYBOX_PATH" \
#sh
