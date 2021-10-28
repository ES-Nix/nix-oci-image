#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix build .#oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp \
&& podman load < result


nix build .#oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp \
&& podman load < result

podman \
build \
--file=src/ex5/Containerfile \
--tag=nix \
--target=nix


#podman rmi localhost/busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:0.0.1
#podman rmi localhost/nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:0.0.1

podman images

#podman create --name nix-volume-container --volume /nix-volume alpine sh
#
#podman \
#run \
#--log-level=error \
#--privileged=false \
#--device=/dev/fuse \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--mount=type=volume,source=nix-volume,target=/nix-volume \
#--network=host \
#--tty=false \
#--rm=true \
#--user=0 \
#localhost/nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
#<<COMMANDS
#cp \
#  --no-dereference \
#  --verbose \
#  /bin/nix \
#  /nix-volume
#COMMANDS

podman \
build \
--cap-add=all \
--network=host \
--file=src/ex5/Containerfile \
--tag=test-nix \
--target=test-nix

#podman \
#run \
#--interactive=true \
#--tty=true \
#--rm=true \
#--user=nixuser \
#--privileged=false \
#--network=host \
#localhost/nix:latest \
#-c 'nix shell nixpkgs#bashInteractive nixpkgs#coreutils nixpkgs#hello --command hello'

#nix profile install nixpkgs#hello
#nix profile install nixpkgs#python3Minimal
#
## Use poetry!
#nix profile install nixpkgs/8635793fceeb6e4b5cf74e63b2dfde4093d7b9cc#python3.pkgs.pip
#pip --version
#pip freeze
#pip install --user flask
#python -c 'import flask'
#export PATH=/home/nixuser/.local/bin:"$PATH"
#python -c 'import flask'
#
#nix shell nixpkgs#bashInteractive
#nix profile install nixpkgs#coreutils
#nix profile install nixpkgs#poetry
#nix profile install nixpkgs#python3
#
#python --version \
#&& mkdir -p "$HOME"/test \
#&& cd "$HOME"/test \
#&& poetry init --no-interaction \
#&& poetry show --tree \
#&& poetry add flask \
#&& poetry lock
#
#cat <<WRAP > "$HOME"/test/flake.nix
#{
#  description = "A usefull description";
#
#  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
#  inputs.flake-utils.url = "github:numtide/flake-utils";
#  inputs.poetry2nix-src.url = "github:nix-community/poetry2nix";
#
#  outputs = { self, nixpkgs, flake-utils, poetry2nix-src }:
#    flake-utils.lib.eachDefaultSystem (system:
#    let
#        pkgsAllowUnfree = import nixpkgs {
#          system = "x86_64-linux";
#          config = { allowUnfree = true; };
#        };
#
#        pkgs = import nixpkgs { inherit system; overlays = [ poetry2nix-src.overlay ]; };
#
#        config = {
#          projectDir = ./.;
#        };
#    in
#    {
#
#      devShell = pkgsAllowUnfree.mkShell {
#
#        buildInputs = with pkgsAllowUnfree; [
#                       poetry
#                       (pkgsAllowUnfree.poetry2nix.mkPoetryEnv config)
#                     ];
#
#          shellHook = ''
#            unset SOURCE_DATE_EPOCH
#          '';
#        };
#  });
#}
#WRAP
#
#nix flake lock
#nix develop --command python -c 'import flask'
#
#
#nix build github:cole-h/nixos-config/6779f0c3ee6147e5dcadfbaff13ad57b1fb00dc7#iso

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
run \
--storage-driver="vfs" \
--cgroups=disabled \
--log-level=error \
--interactive=true \
--network=host \
--tty=true \
docker.io/library/alpine:3.14.0 \
sh \
-c 'apk add --no-cache curl && echo PinP'
COMMANDS

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
--log-level=error \
--storage-driver="vfs" \
images

podman \
--log-level=error \
--storage-driver="vfs" \
images
COMMANDS


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
run \
--cgroups=disabled \
--env=PATH=/root/.nix-profile/bin:/usr/bin:/bin \
--events-backend=file \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--privileged=true \
--tty=false \
--rm=true \
--storage-driver="vfs" \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
docker.nix-community.org/nixpkgs/nix-flakes \
<<COMMANDSNESTED
mkdir --parent --mode=0755 ~/.config/nix
echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf
nix \
profile \
install \
github:ES-Nix/podman-rootless/from-nixpkgs \
&& mkdir --parent --mode=0755 /var/tmp \
&& podman \
run \
--events-backend=file \
--storage-driver="vfs" \
--cgroups=disabled \
--log-level=error \
--interactive=true \
--network=host \
--tty=true \
docker.io/library/alpine:3.14.0 \
sh \
-c 'apk add --no-cache curl && echo PinPinP'
COMMANDSNESTED
COMMANDS


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
run \
--events-backend=file \
--storage-driver="vfs" \
--cgroups=disabled \
--log-level=error \
--interactive=true \
--network=host \
--tty=true \
--user=0 \
--userns=host \
docker.io/library/alpine:3.14.0 \
sh \
-c \
'echo Hello!'
COMMANDS

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=keep-id \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
--volume=/dev/shm:/dev/shm:rw \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
pull \
--log-level=error \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
docker.io/library/alpine:3.14.0
toybox echo '=============='
podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
images
COMMANDS


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=keep-id \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
--volume=/dev/shm:/dev/shm:rw \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/test-nix:latest \
<<COMMANDS
toybox stat /dev/fuse
podman \
run \
--device=/dev/fuse \
--events-backend=file \
--log-level=error \
--interactive=true \
--network=host \
--privileged=true \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
--tty=true \
--user=0 \
--userns=host \
docker.io/library/alpine:3.14.0 \
sh \
-c \
'echo Hello!'
toybox echo '=============='
podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
images
COMMANDS


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=keep-id \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
--volume=/dev/shm:/dev/shm:rw \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/test-nix:latest \
<<COMMANDS
podman \
run \
--cgroups=disabled \
--device=/dev/fuse \
--events-backend=file \
--log-level=error \
--interactive=true \
--network=host \
--privileged=true \
--storage-driver="vfs" \
--tty=true \
--user=0 \
--userns=host \
docker.io/library/alpine:3.14.0 \
sh \
-c \
'echo Hello!'
COMMANDS

#podman \
#run \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--log-level=error \
#--network=host \
#--mount=type=tmpfs,destination=/var/lib/containers \
#--privileged=true \
#--tty=true \
#--rm=true \
#--user=nixuser \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
#--volume=/etc/localtime:/etc/localtime:ro \
#localhost/nix:latest


#nix shell nixpkgs#bashInteractive nixpkgs#coreutils
#
#export PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile:/nix/var/nix/profiles/per-user/nixuser/profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:"$PATH"
#
#nix \
#profile \
#install \
#nixpkgs#hello

#nix \
#build \
#github:ES-Nix/podman-rootless/from-nixpkgs

# nix run nixpkgs#xorg.xclock

#xhost + \
#&& podman \
#run \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--log-level=error \
#--network=host \
#--mount=type=tmpfs,destination=/var/lib/containers \
#--privileged=true \
#--tty=true \
#--rm=true \
#--user=nixuser \
#--volume=/etc/localtime:/etc/localtime:ro \
#--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
#localhost/nix:latest \
#nix run nixpkgs#xorg.xclock \
#&& xhost -
#
#
#
#nix \
#build \
#--store "$(pwd)/test" \
#github:ES-Nix/poetry2nix-examples/424f84dbc089f448a7400292f78b903e44c7f074#poetry2nixOCIImage
#
#nix \
#build \
#--store "$(pwd)/nix" \
#--no-link \
#nix build github:NixOS/nix/9feca5cdf64b82bfb06dfda07d19d007a2dfa1c1#nix-static