
```bash
./src/ex9/test.sh
```

```bash
sudo mkdir -p /etc/ssh

echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd

nix profile install nixpkgs#openssh

SSHD_NIX_PATH=$(nix eval --raw nixpkgs#openssh)/bin/sshd
echo '#!/bin/sh' >> entrypoint.sh
echo 'ssh-keygen -A' >> entrypoint.sh
echo 'exec '"${SSHD_NIX_PATH}"' -D -e "$@"' >> entrypoint.sh

chmod +x entrypoint.sh

sudo cp $(nix eval --raw nixpkgs#openssh)/etc/ssh/sshd_config /etc/ssh/sshd_config

sudo sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config

sudo mkdir -p /var/empty
sudo mkdir -m 0755 /run
sudo ./entrypoint.sh 

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
localhost/nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su:0.0.1 \
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
