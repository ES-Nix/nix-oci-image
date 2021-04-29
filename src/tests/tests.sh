#!/usr/bin/env sh
# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

#./test_hello_sudoless.sh
#./test_channel.sh
#./test_flake.sh
#test_long_builds.sh


#echo 'Start' \
#&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
#&& NIX_CACHE_VOLUME='nix-cache-volume' \
#&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
#&& docker run \
#--cap-add ALL \
#--cpus='0.99' \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive \
#--mount source="$NIX_CACHE_VOLUME",target=/nix \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.cache/ \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.config/nix/ \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.nix-defexpr/ \
#--mount source="$NIX_CACHE_VOLUME_TMP",target=/tmp/ \
#--net=host \
#--privileged=true \
#--tty \
#--rm \
#--workdir /code \
#--volume="$(pwd)":/code \
#--volume="$XAUTHORITY":/root/.Xauthority \
#--volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix \
#--volume=/var/run/docker.sock:/var/run/docker.sock \
#"$NIX_BASE_IMAGE" bash -c 'nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes'\
#&& echo 'End'

#xhost +
#podman \
#run \
#--env="DISPLAY=${DISPLAY:-:0}" \
#--interactive=true \
#--tty=true \
#--rm=true \
#--workdir=/code \
#--volume="$(pwd)":/code \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix \
#python:3.9 \
#bash \
#-c \
#"id && echo \$DISPLAY && python -c 'from tkinter import Tk; Tk()'"
#xhost -
#
#unset DISPLAY
#echo $DISPLAY
#export DISPLAY=':0'
#echo $DISPLAY


./src/tests/load_and_commit.sh

./src/tests/test_flake.sh
