#!/usr/bin/env sh

# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail



nix build .#empty

podman load < result

podman images


# docker shows wrong size 0B
#docker load < result
#docker images


nix build .#slim
podman load < result

nix build .#nix_runAsRoot
podman load < result


./src/tests/tests.sh
