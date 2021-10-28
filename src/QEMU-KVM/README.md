

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
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-flake-nested-qemu-kvm-vm:latest \
bash \
-c \
'./result/runVM'
```

```bash
podman \
run \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=false \
--tty=true \
--rm=true \
--userns=host \
--user=0 \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-flake-nested-qemu-kvm-vm-l:latest
```

TODO: change its name to nix-sudo-su
```bash
./src/ex7/test.sh

podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--log-level=error \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=false \
--tty=true \
--rm=true \
--userns=host \
--user=nixuser \
--volume=/etc/localtime:/etc/localtime:ro \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-chmod:latest \
-c \
'sudo toybox id'
```


nix \
shell \
nixpkgs#mount \
nixpkgs#coreutils \
nixpkgs#bashInteractive \
nixpkgs#which \
nixpkgs#ripgrep \
nixpkgs#strace \
nixpkgs#neovim

Redirect to a file and take its hash
strace -f su
