{ pkgs ? import <nixpkgs> { }}:
pkgs.runCommand "oci-nix-toybox-test"
    { buildInputs = with pkgs; [ ]; }
    ''

      mkdir $out

      cat <<WRAP > $out/build_load
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      rm -rf oci.tar.gz
      nix build .#oci.nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp --out-link oci.tar.gz
      podman load < oci.tar.gz
      rm -rf oci.tar.gz

      BASE='localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
      CONTAINER='container-to-be-commited'
      NIX_IMAGE='nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1'

      podman rm --force --ignore "\$CONTAINER"
      podman \
      run \
      --interactive=true \
      --name="\$CONTAINER" \
      --tty=false \
      --rm=false \
      --user='0' \
      "\$BASE" \
      << COMMANDS
        toybox mkdir /nix
        toybox chmod 0755 -R /home/nixuser/ /nix
        toybox chmod 0700 /home/nixuser
        toybox chmod 1777 /tmp
        toybox chown nixuser:nixgroup -R /home/nixuser /nix
        # chmod 0700 /root /etc
      COMMANDS

      ID=\$(
        podman \
        commit \
        "\$CONTAINER" \
        "\$NIX_IMAGE"
      )

      podman rm --force --ignore "\$CONTAINER"
      WRAP
      chmod +x $out/build_load

      #
      cat <<WRAP > $out/tests
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
        podman \
        run \
        --env='DISPLAY=:0.0' \
        --env='USER=nixuser' \
        --env='HOME=/home/nixuser' \
        --interactive=true \
        --tty=false \
        --rm=true \
        --user='nixuser' \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1 \
        << COMMANDS
        echo 'Running test'
        toybox id
        nix shell nixpkgs#xorg.xclock --command toybox timeout 2 xclock
        nix shell nixpkgs#bashInteractive nixpkgs#coreutils --command id
        exit 0
        COMMANDS
      xhost -
      WRAP
      chmod +x $out/tests

      cat <<WRAP > $out/test_kvm_nixuser
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
        podman \
        run \
        --env='DISPLAY=:0.0' \
        --env='USER=nixuser' \
        --env='HOME=/home/nixuser' \
        --interactive=true \
        --tty=false \
        --rm=true \
        --user='nixuser' \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1 \
        << COMMANDS
        echo 'Running test'
        toybox id
        nix build github:ES-Nix/nix-qemu-kvm/dev#qemu.prepare
        toybox timeout 50 result/runVM
        exit 0
        COMMANDS
      xhost -
      WRAP
      chmod +x $out/test_kvm_nixuser

      cat <<WRAP > $out/test_kvm_root
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
        podman \
        run \
        --env='DISPLAY=:0.0' \
        --env='USER=root' \
        --env='HOME=/root' \
        --interactive=true \
        --tty=false \
        --rm=true \
        --user='0' \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1 \
        << COMMANDS
        echo 'Running test'
        toybox id
        nix build github:ES-Nix/nix-qemu-kvm/dev#qemu.prepare
        toybox timeout 50 result/runVM
        exit 0
        COMMANDS
      xhost -
      WRAP
      chmod +x $out/test_kvm_root

      #
      cat <<WRAP > $out/runOCI
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      podman \
      run \
      --env='DISPLAY=:0.0' \
      --env='USER=nixuser' \
      --env='HOME=/home/nixuser' \
      --interactive=true \
      --tty=true \
      --rm=true \
      --user='nixuser' \
      --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
      localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1

      WRAP
      chmod +x $out/runOCI

    '';

