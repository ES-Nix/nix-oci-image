#!/usr/bin/env sh

CONTAINER='nix-oci-dockertools-user-with-sudo-base-container-to-commit'
DOCKER_OR_PODMAN=podman
NIX_BASE_IMAGE='localhost/nix:0.0.1'
NIX_STAGE_1='localhost/stage-1'
NIX_IMAGE='localhost/nix-post-processed:0.0.1'


#nix build .#nixOCIImage
#"$DOCKER_OR_PODMAN" load < result

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


podman volume rm --force volume_etc
podman volume create volume_etc
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_etc:/code \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh \
<< COMMAND

cat << 'EOF' >> /etc/passwd
adauser:x:6789:12345::/home/adauser:/bin/bash
nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin
nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin
nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin
nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin
nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin
nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin
nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin
nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin
nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin
nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin
nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin
nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin
nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin
nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin
nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin
nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin
nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin
nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin
nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin
nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin
nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin
nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin
nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin
nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin
nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin
nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin
nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin
nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin
nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin
nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin
nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin
nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin
EOF

cat << 'EOF' >> /etc/group
nix_group:x:12345:
nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32
EOF

mkdir -p /code/ssl/certs/

cp -r /etc/passwd /code/passwd
cp -r /etc/group /code/group
cp -r /etc/ssl/certs/ /code/ssl/
COMMAND

#podman \
#run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=volume_etc:/code \
#--user='0' \
#docker.io/library/alpine:3.13.0 \
#sh \
#<< COMMAND
#
# apk add --no-cache shadow \
# && groupadd --gid 30000 nixbld \
# && for n in $(seq 1 32); do \
#    useradd \
#    --comment "Nix build user $n" \
#    --gid nixbld \
#    --groups nixbld \
#    --home-dir /var/empty \
#    --no-create-home \
#    --no-user-group \
#    --shell "$(which nologin)" \
#    --system \
#    nixbld$n; done
#
# groupadd --gid 12345 adagroup \
# && useradd \
#    --create-home \
#    --no-log-init \
#    --uid 6789 \
#    --gid adagroup adauser
#
#cp /etc/ssl/certs/ca-certificates.crt /code/etc/ssl/certs/ca-certificates.crt
#
#cp /etc/passwd /code/etc/
#cp /etc/group /code/etc/
#COMMAND

rm -f oci_diff.txt
podman diff "$CONTAINER" > oci_diff.txt

#ID=$(
#  "$DOCKER_OR_PODMAN" \
#  commit \
#  "$CONTAINER" \
#  "$NIX_IMAGE"
#)
#
#"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"

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

#podman volume rm --force volume_unpiviliged_user
#podman volume create volume_unpiviliged_user
#
#podman \
#run \
#--interactive=true \
#--name="$CONTAINER" \
#--tty=false \
#--rm=false \
#--volume=volume_nix_static:/home/adauser/bin:ro \
#--volume=volume_etc:/etc/:ro \
#--volume=volume_unpiviliged_user:/code \
#--workdir=/home/adauser \
#--user='0' \
#docker.io/library/alpine:3.13.0 \
#sh \
#<< COMMAND
#
#export USER=root
#
#/home/adauser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store /home/adauser \
#build \
#nixpkgs#cowsay \
#--out-link \
#result
#
##cd /home/adauser/nix/store
##rm -rf *
##cd /home/adauser
#
#/home/adauser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store \
#/home/adauser \
#store \
#gc
#
#rm -rf /.cache
#cp /home/adauser/nix /code/
#COMMAND


#podman \
#run \
#--interactive=true \
#--name="$CONTAINER" \
#--tty=true \
#--rm=true \
#--volume=volume_nix_static:/home/adauser/bin:ro \
#--volume=volume_etc:/etc:ro \
#--volume=volume_unpiviliged_user:/home/adauser/nix \
#--workdir=/home/adauser \
#--user='0' \
#localhost/docker-tools-empty-image-size:0.0.1 \
#bash





#"$DOCKER_OR_PODMAN" \
#run \
#--interactive=true \
#--name="$CONTAINER" \
#--tty=true \
#--rm=false \
#--user=0 \
#--volume="$(pwd)":/root/code \
#--volume=volume_ca_certificate:/etc/ssl/certs:ro \
#"$NIX_BASE_IMAGE" \
#nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#shell \
#nixpkgs#bashInteractive \
#nixpkgs#coreutils \
#--command \
#bash \
#-c \
#"./root/code/process.sh"

#podman \
#run \
#--interactive=true \
#--tty=true \
#--rm=false \
#--volume=volume_nix_static:/home/adauser/bin:ro \
#--volume=volume_etc:/etc/:ro \
#--volume=volume_unpiviliged_user:/home/adauser/nix/:rw \
#--user='0' \
#docker.io/library/alpine:3.13.0 \
#sh


#podman \
#run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=volume_nix_static:/home/adauser/bin:ro \
#--volume=volume_etc:/etc/:ro \
#--user='0' \
#docker.io/library/alpine:3.13.0 \
#sh \
#<< COMMAND
#echo 'Starting test:'
#
#echo 'pwd: ' $(pwd)
#
#export USER=root
#/home/adauser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store /home/adauser \
#build \
#nixpkgs#cowsay \
#--out-link \
#result
#
#ls -ahl
#
#COMMAND


#podman \
#run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=volume_nix_static:/home/adauser/bin:ro \
#--volume=volume_etc:/etc/:ro \
#--user='0' \
#docker.io/library/busybox:1.32.1-musl \
#sh \
#<< COMMAND
#echo 'Starting test:'
#
#echo 'pwd: ' $(pwd)
#
#export USER=root
#/home/adauser/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store /home/adauser \
#build \
#nixpkgs#cowsay \
#--out-link \
#result
#
#ls -ahl
#
#COMMAND

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--volume=volume_nix_static:/home/adauser/bin:ro \
--volume=volume_etc:/etc/:ro \
--user='0' \
docker.io/tianon/toybox:0.8.4 \
bash \
<< COMMAND
echo 'Starting test:'

echo 'pwd:' \$(pwd)

export USER=root
/home/adauser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/adauser \
build \
nixpkgs#cowsay \
--out-link \
result
ls -ahl
COMMAND
