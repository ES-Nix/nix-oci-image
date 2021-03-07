#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix-build --attr image



CONTAINER='nix-oci-dockertools-user-with-sudo-base-container-to-commit'
DOCKER_OR_PODMAN=podman
NIX_BASE_IMAGE='nix-oci-dockertools-user-with-sudo-base:0.0.1'

"$DOCKER_OR_PODMAN" load < result

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


"$DOCKER_OR_PODMAN" \
run \
--cap-add=ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=USER=pedroregispoar \
--env=HOME=/home/pedroregispoar \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code \
"$NIX_BASE_IMAGE" \
bash \
<< COMMANDS
sudo chmod +x /home/pedroregispoar/flake_requirements.sh
/home/pedroregispoar/flake_requirements.sh
COMMANDS

ID=$("$DOCKER_OR_PODMAN" \
commit \
"$CONTAINER" \
nix-oci-dockertools-user-with-sudo:0.0.1)

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"

#./test_flake.sh
./test_hello_sudoless.sh


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