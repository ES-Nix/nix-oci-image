#!/usr/bin/env sh


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


# TODO: it is all broken
#podman run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--user=pedroregispoar \
#--workdir=/code \
#--volume="$(pwd)":/code \
#"$IMAGE_VERSION" \
#bash \
#<< COMMANDS
#sudo --preserve-env
#echo 'Start build image'
#nix-build --attr image
#echo 'End build image'
#COMMANDS
#
#
#podman run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--user=pedroregispoar \
#--workdir=/code \
#--volume="$(pwd)":/code \
#"$IMAGE_VERSION" \
#bash \
#<< COMMANDS
#sudo --preserve-env
#echo 'Start build image'
#sudo --preserve-env --set-home nix-build --attr image
#echo 'End build image'
#COMMANDS
#
#
#podman run \
#--interactive=true \
#--tty=false \
#--rm=true \
#--user=0 \
#--workdir=/code \
#--volume="$(pwd)":/code \
#"$IMAGE_VERSION" \
#bash \
#<< COMMANDS
#sudo --preserve-env
#echo 'Start build image'
#nix-build --attr image
#echo 'End build image'
#COMMANDS