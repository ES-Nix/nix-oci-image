#!/usr/bin/env sh

#sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixos-20.09 nixos \
# && sudo --preserve-env nix-channel --list \
# && sudo --preserve-env nix-channel --update \
# && sudo --preserve-env nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
# && sudo --preserve-env nix-channel --update

IMAGE_VERSION='localhost/nix-oci-dockertools-user-with-sudo:0.0.1'

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
sudo --preserve-env id
COMMANDS

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
sudo su -c 'env'
COMMANDS

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
sudo --preserve-env su -c 'env'
COMMANDS


echo 'Running: ''nix --version'
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
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix --version'
COMMANDS

echo 'Running: ''nix flake --help'
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
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake --help'
COMMANDS


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

echo 'Running: ''nix-env GNU hello'
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
sudo --preserve-env \
nix-env \
--file "<nixpkgs>" \
--install --attr hello \
--show-trace
hello
COMMANDS


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
sudo --preserve-env \
nix-shell \
-I nixpkgs=channel:nixos-20.09 \
--packages nixFlakes \
--run 'nix shell nixpkgs#cowsay --command cowsay Hi from nix shell nixpkgs#cowsay!'
COMMANDS


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
sudo --preserve-env
echo 'Start build image'
nix-build --attr image
echo 'End build image'
cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) result2
COMMANDS
