#!/usr/bin/env sh

#set -x

nix build .#nix_runAsRoot

podman load < result

CONTAINER=foo-bar
podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=true \
--user='nixuser' \
localhost/nix-run-as-root:0.0.1 \
/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
--command \
bash \
<< COMMAND
id
du --human-readable --max-depth=1 --exclude /proc /
echo
env
exit 0
COMMAND

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user='nixuser' \
--volume="$(pwd)":/code \
--workdir=/code \
localhost/nix-run-as-root:0.0.1 \
bash \
<< COMMAND

/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#python3Minimal \
--command \
python --version
COMMAND


#podman \
#run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--user='0' \
#--volume="$(pwd)":/code \
#--workdir=/code \
#localhost/nix-run-as-root:0.0.1 \
#bash \
#<< COMMAND
#
#/bin/nix \
#--experimental-features \
#'nix-command ca-references flakes' \
#--store \
#/home/nixuser \
#shell \
#nixpkgs#python3Minimal \
#--command \
#python --version
#COMMAND