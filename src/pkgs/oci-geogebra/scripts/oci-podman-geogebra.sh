#!/usr/bin/env bash



# TODO: repeat this `if/else/if` every where is bad, it is not DRY
$(nix flake metadata .# 1> /dev/null 2> /dev/null)
is_local=$?
if [[ ${is_local} ]]; then
  echo 'Locally building'
  nix build --refresh .#oci-geogebra \
  && podman load < result
else
  echo 'Remote building'
  nix build --refresh github:ES-Nix/nix-oci-image/nix-static-minimal#oci-geogebra \
  && podman load < result
fi

#podman \
#build \
#--file Containerfile \
#--tag oci-chromium \
#--target oci-busybox-sandbox-shell \
#.

podman images

xhost +
podman \
run \
--device=/dev/kvm \
--device=/dev/fuse \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--mount=type=tmpfs,destination=/var/lib/containers \
--privileged=true \
--tty=true \
--rm=true \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--user=nixuser \
--workdir=/home/nixuser \
localhost/oci-podman-geogebra:latest
xhost -

#xhost +
#podman \
#run \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive=true \
#--tty=false \
#--rm=true \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
#localhost/oci-podman-chromium:latest \
#<< COMMANDS
#timeout 30 chromium --no-sandbox || test $? -eq 124 || echo 'Error'
#COMMANDS
#xhost -



