#!/usr/bin/env sh

CONTAINER='nix-oci-dockertools-user-with-sudo-base-container-to-commit'
DOCKER_OR_PODMAN=podman
NIX_BASE_IMAGE='localhost/nix-oci-dockertools-user-sudoless:0.0.1'
NIX_STAGE_1='localhost/stage-1'
NIX_IMAGE='localhost/nix-oci-dockertools-user-sudoless-post-processed:0.0.1'

"$DOCKER_OR_PODMAN" load < result

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


"$DOCKER_OR_PODMAN" \
run \
--cap-add=ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env="TMPDIR=/home/pedroregispoar/tmp" \
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
#/home/pedroregispoar/flake_requirements.sh

chmod 0700 /home/pedroregispoar
chmod 0755 -R /nix/ /home/pedroregispoar
chmod 1777 /home/pedroregispoar/tmp

chown pedroregispoar:pedroregispoargroup -R /home/pedroregispoar /nix/
nix-collect-garbage --delete-old && nix-store --optimise
cd /tmp && rm -frv *
COMMANDS
#<< COMMANDS
#./flake_requirements.sh
#COMMANDS


ID=$(
  "$DOCKER_OR_PODMAN" \
  commit \
  "$CONTAINER" \
  "$NIX_STAGE_1"
)

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"



"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


"$DOCKER_OR_PODMAN" \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env="TMPDIR=/home/pedroregispoar/tmp" \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code \
"$NIX_STAGE_1" \
bash \
<< COMMANDS
export TMPDIR=/home/pedroregispoar/tmp


stat /home/pedroregispoar
stat /home/pedroregispoar/tmp

nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#hello --command hello'
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix-collect-garbage --delete-old && nix-store --optimise'

cd /home/pedroregispoar/tmp && rm -frv *

COMMANDS

ID=$(
  "$DOCKER_OR_PODMAN" \
  commit \
  "$CONTAINER" \
  "$NIX_IMAGE"
)

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"