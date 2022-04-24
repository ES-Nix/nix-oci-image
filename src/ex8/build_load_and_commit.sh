#!/usr/bin/env sh

BASE_IMAGE='localhost/nix-aux'
CONTAINER='container-to-commit'
IMAGE='nix-chmod'
TAG="${1:-latest}"

podman rm --force --ignore "$CONTAINER"

podman \
run \
--interactive=true \
--name="$CONTAINER" \
--network=host \
--privileged=true \
--tty=false \
--rm=false \
--user=0 \
"$BASE_IMAGE" \
<< COMMANDS
toybox chmod -Rv 4755 /bin/sudo
COMMANDS

ID=$(podman \
commit \
"$CONTAINER" \
"$IMAGE":"$TAG"
)

podman rm --force --ignore "$CONTAINER"