#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix-build --attr image


docker load < result
#
#echo 'Start' \
#&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
#&& NIX_CACHE_VOLUME='nix-cache-volume' \
#&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
#&& docker run -it "$NIX_BASE_IMAGE" bash -c 'chmod +x home/pedroregispoar/flake_requirements.sh && ./home/pedroregispoar/flake_requirements.sh'
#
#
#echo 'Start' \
#&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
#&& NIX_CACHE_VOLUME='nix-cache-volume' \
#&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
#&& docker run -it "$NIX_BASE_IMAGE" bash -c '

#nix develop github:ES-Nix/podman-rootless/324855d116d15a0b54f33c9489cf7c5e6d9cd714 --command ./test_flake.sh

#docker run \
#--interactive \
#--rm \
#--workdir /code \
#--volume="$(pwd)":/code \
#lnl7/nix:2.3.7 bash -c './flake_test.sh'

#docker run \
#--interactive \
#--rm \
#lnl7/nix:2.3.7 bash -c 'nix-env --install --attr nixpkgs.curl && curl -fsSL https://raw.githubusercontent.com/ES-Nix/get-nix/e47ab707cfd099a6669e7a2e47aeebd36e1c101d/install-lnl7-oci.sh | sh && . ~/.bashrc && flake'


echo 'Start' \
&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
&& NIX_CACHE_VOLUME='nix-cache-volume' \
&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
&& docker run \
--cap-add ALL \
--cpus='0.99' \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive \
--name=contianer_to_commit \
--tty \
--rm=false \
--workdir /code \
--volume="$(pwd)":/code \
"$NIX_BASE_IMAGE" bash -c './flake_requirements.sh'\
&& echo 'End'

ID=$(docker container ls --filter "status=exited" | grep contianer_to_commit | cut --delimiter=' ' --fields=1)

docker commit "$ID" nix-oci-dockertools-commit:0.0.1



#echo 'Start' \
#&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
#&& NIX_CACHE_VOLUME='nix-cache-volume' \
#&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
#&& docker run \
#--cap-add ALL \
#--cpus='0.99' \
#--device=/dev/kvm \
#--env="DISPLAY=${DISPLAY:-:0.0}" \
#--interactive \
#--mount source="$NIX_CACHE_VOLUME",target=/nix \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.cache/ \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.config/nix/ \
#--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.nix-defexpr/ \
#--mount source="$NIX_CACHE_VOLUME_TMP",target=/tmp/ \
#--net=host \
#--privileged=true \
#--tty \
#--rm \
#--workdir /code \
#--volume="$(pwd)":/code \
#--volume="$XAUTHORITY":/root/.Xauthority \
#--volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
#--volume=/tmp/.X11-unix:/tmp/.X11-unix \
#--volume=/var/run/docker.sock:/var/run/docker.sock \
#"$NIX_BASE_IMAGE" bash -c 'nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes'\
#&& echo 'End'