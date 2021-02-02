#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail


nix-build --attr image


#docker load < result
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
