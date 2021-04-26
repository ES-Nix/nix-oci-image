#!/usr/bin/env sh
# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail


IMAGE_VERSION='localhost/nix-oci-dockertools-user-sudoless-post-processed:0.0.1'

echo 'Running: ''flake GNU hello'
podman run \
--interactive=true \
--tty=false \
--rm=true \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code \
"$IMAGE_VERSION" \
bash \
<< COMMANDS
export TMPDIR=/home/pedroregispoar/tmp
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#hello --command hello'
COMMANDS

IMAGE_VERSION='localhost/nix-oci-dockertools-user-sudoless-post-processed:0.0.1'
podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code/p1 \
--volume="$(pwd)":/code/p2 \
"$IMAGE_VERSION"


IMAGE_VERSION='localhost/nix-oci-dockertools-user-sudoless-post-processed:0.0.1'
podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code/p1 \
--volume="$(pwd)":/code/p2 \
"$IMAGE_VERSION"

