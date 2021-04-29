#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix build .#emptyImageZeroSize
podman load < result


podman volume rm --force volume_nix_static
podman volume create volume_nix_static

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_nix_static:/code \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh \
<< COMMAND
apk add --no-cache curl
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix
sha256sum nix
chmod +x ./nix
cp nix /code/
COMMAND


podman volume rm --force volume_etc
podman volume create volume_etc
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/code \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh \
<< COMMAND
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
build \
nixpkgs#cacert

ls -ahl result/etc/ssl/certs

mkdir --parent /code/ssl/certs
cp result/etc/ssl/certs/ca-bundle.crt /code/ssl/certs/ca-bundle.crt
#echo 'nixuser:x:12345:6789::/home/nixuser:/bin/bash' > /code/passwd
#echo 'nixgroup:x:6789:' > /code/group
#
#echo 'nixuser:!:::::::' > /code/shadow
#echo 'nixgroup:x::' > /code/gshadow

COMMAND

podman volume rm --force volume_tmp
podman volume create volume_tmp
#podman \
#run \
#--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
#--env=USER=nixuser \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=volume_nix_static:/home/nixuser/bin:ro \
#--volume=volume_etc:/etc:ro \
#--volume=volume_tmp:/tmp/:rw \
#--user='0' \
#localhost/empty-image-zero-size:0.0.1 \
#/home/nixuser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store /home/nixuser \
#shell \
#nixpkgs#bashInteractive \
#nixpkgs#coreutils \
#--command \
#bash \
#-c \
#'id'


#podman volume rm --force volume_store
#podman volume create volume_store
#podman \
#run \
#--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
#--env=HOME=/home/nixuser \
#--env=USER=nixuser \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=volume_nix_static:/home/nixuser/bin:ro \
#--volume=volume_etc:/etc:ro \
#--volume=volume_tmp:/tmp/:rw \
#--volume=volume_store:/home/nixuser:rw \
#--workdir=/home/nixuser \
#--user='nixuser' \
#localhost/empty-image-zero-size:0.0.1 \
#/home/nixuser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store /home/nixuser \
#shell \
#nixpkgs#bashInteractive \
#nixpkgs#coreutils \
#--command \
#bash \
#-c \
#'id'


podman \
run \
--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
--env=HOME=/home/nixuser \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_tmp:/tmp/:rw \
--volume=volume_store:/home/nixuser:rw \
--workdir=/home/nixuser \
--user='nixuser' \
localhost/empty-image-zero-size:0.0.1 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--version

podman \
run \
--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
--env=HOME=/home/nixuser \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_tmp:/tmp/:rw \
--workdir=/home/nixuser \
--user='0' \
localhost/empty-image-zero-size:0.0.1 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#shadow \
--command \
bash


podman \
run \
--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
--env=HOME=/home/nixuser \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_tmp:/tmp/:rw \
--workdir=/home/nixuser \
--user='0' \
localhost/empty-image-zero-size:0.0.1 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#shadow \
--command \
bash

#--volume=volume_store:/home/nixuser:rw \

#\
#<< COMMAND
#groupadd --gid 12345 nixgroup \
#&& useradd \
#  --no-create-home \
#  --no-log-init \
#  --uid 6789 \
#  --gid nixgroup nixuser
#
#chown nixuser:nixgroup -R /home/nixuser
#chmod 0755 -R /home/nixuser/
#chmod 0700 /home/nixuser
#COMMAND
#du --human-readable --max-depth=1 --exclude /proc /

podman \
run \
--env=NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
--env=HOME=/home/nixuser \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc/:ro \
--volume=volume_tmp:/tmp/:rw \
--workdir=/home/nixuser \
--user='nixuser' \
localhost/nix:0.0.1 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#shadow \
--command \
bash

