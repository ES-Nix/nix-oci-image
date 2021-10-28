#!/usr/bin/env sh

BASE_IMAGE='docker.nix-community.org/nixpkgs/nix-flakes'
CONTAINER='income-back-container-to-commit'
IMAGE='nix-flake-nested-qemu-kvm-vm'
TAG="${1:-latest}"

podman rm --force --ignore "$CONTAINER"

podman \
run \
--device=/dev/kvm \
--interactive=true \
--name="$CONTAINER" \
--network=host \
--privileged=true \
--tty=false \
--rm=false \
--user=0 \
"$BASE_IMAGE" \
bash \
<< COMMANDS
mkdir --parent --mode=0755 ~/.config/nix
echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf
echo Begined
nix build github:ES-Nix/nix-qemu-kvm/dev#qemu.prepare
echo End
nix-collect-garbage --delete-old
nix store gc
COMMANDS

ID=$(podman \
commit \
"$CONTAINER" \
--change=ENV=PATH=/root/.nix-profile/bin:/usr/bin:/bin \
"$IMAGE":"$TAG"
)

podman rm --force --ignore "$CONTAINER"