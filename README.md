

[Jérôme Petazzoni - Creating Optimized Images for Docker and Kubernetes](https://www.youtube.com/watch?v=UbXv-T4IUXk&list=PLf-O3X2-mxDmn0ikyO7OF8sPr2GDQeZXk&index=15)

It looks like it is possible to the same "trick" [Jérôme Petazzoni](put some usefull url here, his github?), 
i mean, install some thing to a profile using [`flake`](add link here) and use the `COPY` thing from 
"Docker multi stage build".

[NYLUG Presents: Sneaking in Nix - Building Production Containers with Nix](https://www.youtube.com/watch?v=pfIDYQ36X0k&t=865s)

[https://www.youtube.com/watch?v=WP_oAmV6C2U](https://www.youtube.com/watch?v=WP_oAmV6C2U)

```bash
nix \
run \
--refresh \
github:ES-Nix/nix-oci-image/nix-static-minimal#oci-podman-nix
```

```bash
nix \
run \
--refresh \
.#oci-podman-nix
```


```bash
nix \
run \
--refresh \
github:ES-Nix/nix-oci-image/nix-static-minimal#oci-podman-nix-sudo-su \
-- \
bash
```

nix run .#oci-podman-nix-sudo-su -- bash -c 'nix run nixpkgs#hello && nix profile install nixpkgs#hello'

```bash
nix \
run \
--refresh \
github:ES-Nix/nix-oci-image/nix-static-minimal#oci-podman-nix-entrypoint
```

```bash
nix \
run \
--refresh \
.#oci-podman-nix-entrypoint
```


It is an OCI image with Ubuntu 16.04 with openssh-server
```bash
nix \
run \
--refresh \
github:ES-Nix/nix-oci-image/nix-static-minimal#oci-podman-openssh-server
```

```bash
nix \
run \
--refresh \
github:ES-Nix/nix-oci-image/nix-static-minimal#oci-podman-nix-toybox-busybox-sandbox-shell-all-static
```

```bash
nix \
run \
--refresh \
.#oci-podman-nix-toybox-busybox-sandbox-shell-all-static
```


```bash
podman \
build \
--file=Containerfile \
--tag=toybox-with-nix-flakes:0.0.1

nix build .#empty
podman load < result
podman \
build \
--file=Containerfile \
--tag=nix-flake \
--target=nix-flake


nix build .#busybox-sandbox-shell \
&& podman load < result \
&& podman \
build \
--file=Containerfile \
--tag=busybox-sandbox-shell-nix-flake \
--target=busybox-sandbox-shell-nix-flake \
&& podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/busybox-sandbox-shell-nix-flake \
<<COMMAND
nix flake --version
COMMAND
&& podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=0 \
localhost/busybox-sandbox-shell-nix-flake \

nix build .#busybox-sandbox-shell-nix-flakes \
&& podman load < result \
&& podman \
build \
--file=Containerfile \
--tag=busybox-sandbox-shell-nix-flake \
--target=busybox-sandbox-shell-nix-flake \
&& podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=0 \
localhost/busybox-sandbox-shell-nix-flake


mkdir -p -m 0755 ~/.config/nix \
&& echo 'system-features = kvm nixos-test' >> ~/.config/nix/nix.conf \
&& echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf \
&& nix shell nixpkgs#bash nixpkgs#hello --command hello

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/toybox-with-nix-flakes:0.0.1 \
<<COMMANDS
nix store gc
. /root/.bashrc
nix shell nixpkgs#bash nixpkgs#hello --command hello
nix store gc
du -hs /nix
COMMANDS
echo $?
```

To test a somewhat difficult build:
```bash
nix build github:cole-h/nixos-config/6779f0c3ee6147e5dcadfbaff13ad57b1fb00dc7#iso
```


```bash
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/toybox-with-nix-flakes:0.0.1 \
<<COMMANDS
nix store gc
. /root/.bashrc
nix shell nixpkgs#bash nixpkgs#hello --command hello
nix store gc
nix build nixpkgs#python3Minimal
result/bin/python -c 'print("Hello")'
nix store gc
du -hs /nix
nix build nixpkgs#hello
result/bin/hello
nix store gc
du -hs /nix
COMMANDS

echo $?
```

stat /proc

podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/alpine-with-hello:0.0.1 \
<<COMMANDS
apk update
hello
COMMANDS

podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
docker.nix-community.org/nixpkgs/nix-flakes


podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
localhost/toybox-with-nix-flakes:0.0.1
nix shell nixpkgs#bashInteractive

podman \
run \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/kvm:/dev/kvm:rw \
localhost/toybox-with-nix-flakes:0.0.1


podman \
run \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--entrypoint="" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/dev/kvm:/dev/kvm:rw \
localhost/toybox-with-nix-flakes:0.0.1


### Running with docker and with --privileged=true



```bash
podman \
save \
toybox-with-nix-flakes:0.0.1 \
--output \
toybox-with-nix-flakes.tar.gz
echo
docker \
load < toybox-with-nix-flakes.tar.gz
echo
docker \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
localhost/toybox-with-nix-flakes:0.0.1 \
<<COMMANDS
stat /dev/kvm
. /root/.bashrc
nix flake --version
nix flake metadata nixpkgs
nix store gc
du -hs /nix
nix build github:ES-Nix/nix-qemu-kvm/22f79c3d114c2b36955989f6742b3430b6d9e9aa#qemu.prepare
rm result
nix store gc
du -hs /nix
COMMANDS
```


### TODO

nix build .#busybox-sandbox-shell-nix-flakes \
&& podman load < result \
&& podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user=0 \
localhost/busybox-sandbox-shell-nix-flakes:0.0.1

mkdir -p /tmp \
&& mkdir -p -m 0755 ~/.config/nix \
&& echo 'system-features = kvm nixos-test' >> ~/.config/nix/nix.conf \
&& echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf
nix shell nixpkgs#bash nixpkgs#hello --command hello

```bash
nix build .#busybox-sandbox-shell-nix-flakes \
&& podman load < result \
&& podman \
build \
--file=Containerfile \
--tag=nix \
--target=busybox-sandbox-shell-nix-flake-patch
```


### Ex 5


./src/ex5/test.sh

podman \
run \
--device=/dev/fuse \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=0 \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/etc/localtime:/etc/localtime:ro \
localhost/nix
nix show nixpkgs#hello
nix shell nixpkgs#hello --command hello
nix build nixpkgs#hello && result/bin/hello

nix profile install nixpkgs#bashInteractive nixpkgs#coreutils



nix \
build \
github:ES-Nix/nix-qemu-kvm/dev#qemu.vm

nix \
profile \
install \
github:ES-Nix/podman-rootless/from-nixpkgs


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
docker.io/library/alpine:3.13.5 \
sh


https://github.com/NixOS/nixpkgs/blob/nixos-21.05/pkgs/os-specific/linux/busybox/default.nix#L143



### TODO: make vlc work!


```bash
xhost + \
&& podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=nixuser \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
localhost/nix:latest \
&& xhost -
```

https://stackoverflow.com/a/28985715


## Building it self


podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--user=nixuser \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/dev/shm:/dev/shm:ro \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/nix:latest

nix \
profile \
install \
nixpkgs#podman

### Podman in Podman


```bash
podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--userns=keep-id \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
--volume=/dev/shm:/dev/shm:rw \
--volume=/dev/snd:/dev/snd:ro \          
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/test-nix:latest

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
pull \
busybox

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
images

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
run \
--interactive=true \
--network=host \
--tty=true \
busybox

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
info \
--debug

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
 stats \
 --cgroup-manager=systemd
```

podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
--volume=/dev/shm:/dev/shm:rw \
--volume=/dev/snd:/dev/snd:ro \
--volume="$(pwd)":/home/nixuser/code:rw \
localhost/test-nix:latest


podman \
--storage-driver="vfs" \
run \
--interactive=true \
--network=host \
--tty=true \
busybox

podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
run \
--interactive=true \
--network=host \
--tty=true \
registry.stage.redhat.io/ubi8/ubi:8.4



podman \
save \
test-nix \
--output test-nix.tar.gz

docker load < test-nix.tar.gz


podman \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
run \
--interactive=true \
--network=host \
--tty=true \
busybox


docker \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest

nix shell nixpkgs#gnugrep
grep cgroup /proc/filesystems

podman \
--cgroup-manager=cgroupfs \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
run \
--log-level=debug \
--interactive=true \
--network=host \
--tty=true \
busybox


podman \
--cgroup-manager=cgroupfs \
--storage-driver="overlay" \
--storage-opt="overlay.mount_program=$(nix eval --raw nixpkgs#fuse-overlayfs)/bin/fuse-overlayfs" \
run \
--log-level=debug \
--interactive=true \
--network=host \
--tty=true \
fedora \
bash


podman \
--cgroup-manager=cgroupfs \
run \
--log-level=debug \
--interactive=true \
--network=host \
--tty=true \
fedora \
bash


Really??
https://bugzilla.redhat.com/show_bug.cgi?id=1732957#c50

docker \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:rw \
localhost/test-nix:latest

```bash
podman \
run \
--cgroups=disabled \
--log-level=debug \
--interactive=true \
--network=host \
--tty=true \
fedora \
bash
```

```bash
podman \
run \
--cgroups=disabled \
--log-level=debug \
--interactive=true \
--network=host \
--tty=true \
alpine \
sh \
-c 'apk add --no-cache curl'
```

```bash
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
alpine \
sh \
-c 'apk add --no-cache curl && echo PinP'
COMMANDS
```


### The "empty" OCI image

```bash
nix build .#oci-empty-image
podman load < result
echo $(nix eval --raw .#oci-empty-image)
podman inspect localhost/empty:0.0.1
```


```bash
nix build .#
podman load < result

podman images

./src/ex9/test.sh
```
