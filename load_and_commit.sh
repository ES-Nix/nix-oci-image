#!/usr/bin/env sh

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
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user=0 \
--workdir=/code \
--volume="$(pwd)":/code \
"$NIX_BASE_IMAGE" \
bash \
<< COMMANDS
chmod +x /home/pedroregispoar/flake_requirements.sh
/home/pedroregispoar/flake_requirements.sh
COMMANDS
#<< COMMANDS
#./flake_requirements.sh
#COMMANDS


ID=$("$DOCKER_OR_PODMAN" \
commit \
"$CONTAINER" \
nix-oci-dockertools-user-with-sudo:0.0.1)

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"