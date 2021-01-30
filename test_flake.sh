#!/usr/bin/env sh

#sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixos-20.09 nixos \
# && sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --update \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
# && sudo --preserve-env nix-channel --update
#
#sudo --preserve-env nix-env --install --attr \
#nixpkgs.commonsCompress \
#nixpkgs.gnutar \
#nixpkgs.lzma.bin \
#nixpkgs.git


podman load < ./result

IMAGE_VERSION='localhost/nix-oci-dockertools:0.0.1'

podman run \
--interactive \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c "sudo ls -al && id"


podman run \
--interactive \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c 'sudo su -c 'env''


podman run \
--interactive \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c 'sudo --preserve-env su -c 'env''


podman run \
--interactive \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c 'sudo --preserve-env nix-env --file "<nixpkgs>" --install --attr hello --show-trace && hello'


podman run \
--interactive \
--privileged \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c 'sudo --preserve-env nix-build --attr image && cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) result2'


podman run \
--interactive \
--privileged \
--tty \
--rm \
--workdir /code \
--volume "$(pwd)":/code \
"$IMAGE_VERSION" bash -c 'sudo --preserve-env nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#cowsay --command cowsay Hi from nix shell nixpkgs#cowsay!''



