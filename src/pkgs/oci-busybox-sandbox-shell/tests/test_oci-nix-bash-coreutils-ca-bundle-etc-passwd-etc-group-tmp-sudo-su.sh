#!/usr/bin/env sh



nix build --refresh .#oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
&& podman load < result


podman \
build \
--file Containerfile \
--tag test-oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su \
--target test-nix \
.


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=nixuser \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
localhost/test-oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su:latest \
<< COMMANDS
id
sudo su -c 'id'
COMMANDS


podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
--interactive=true \
--network=host \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=false \
--rm=true \
--userns=host \
--user=nixuser \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
localhost/test-oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su:latest \
<< COMMANDS
nix build nixpkgs#hello
nix profile install nixpkgs#hello
hello
nix profile list
COMMANDS

