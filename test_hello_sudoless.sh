#!/usr/bin/env sh

#sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixos-20.09 nixos \
# && sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --update \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
# && sudo --preserve-env nix-channel --update

IMAGE_VERSION='localhost/nix-oci-dockertools-user-with-sudo:0.0.1'

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
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#hello --command hello'
COMMANDS
