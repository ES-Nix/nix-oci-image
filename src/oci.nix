{ pkgs ? import <nixpkgs> { }, podman-rootless }:
rec {
  nix_runAsRoot = import ./nix_runAsRoot.nix {
    pkgs = pkgs;
  };

  nix_runAsRoot_minimal = import ./nix_runAsRoot_minimal.nix {
    pkgs = pkgs;
  };

  empty = import ./empty-oci.nix {
    pkgs = pkgs;
  };

  nix-unpriviliged = import ./nix-unpriviliged.nix {
    pkgs = pkgs;
  };

  toybox-static-oci = import ./toybox-static-oci.nix {
    pkgs = pkgs;
  };

  toybox = import ./toybox.nix {
    pkgs = pkgs;
  };

  toybox-oci-nixpkgs = import ./toybox-oci-nixpkgs.nix {
    pkgs = pkgs;
  };

  build-environment-to-build-toybox-staticaly = import ./build-environment-to-build-toybox-staticaly.nix {
    pkgs = pkgs;
  };

  nix-static-ca-bundle-etc-passwd-etc-group-tmp = import ./nix-static-ca-bundle-etc-passwd-etc-group-tmp.nix {
    pkgs = pkgs;
  };

  nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp = import ./nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp.nix {
    pkgs = pkgs;
  };

  oci-ca-bundle = import ./oci-ca-bundle.nix {
    pkgs = pkgs;
  };

  nix-static-bare = import ./nix-static-bare.nix {
    pkgs = pkgs;
  };

  nix-static-bash-interactive-coreutils = import ./nix-static-bash-interactive-coreutils.nix {
    pkgs = pkgs;
  };

  tests = import ./tests.nix {
    pkgs = pkgs;
  };

  tests_nix-static-bash-interactive-coreutils = import ./tests_nix-static-bash-interactive-coreutils.nix {
    pkgs = pkgs;
  };

  nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp.nix {
    pkgs = pkgs;
  };

  nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp.nix {
    pkgs = pkgs;
  };

  tests_podman-rootles = import ./tests_podman-rootles.nix {
    pkgs = pkgs;
    podman-rootless = podman-rootless;
  };

  future = import ./oci-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp.nix {
    pkgs = pkgs;
  };

  nix-toybox-test = pkgs.runCommand "oci-nix-toybox-test"
    { buildInputs = with pkgs; [ ]; }
    ''
      export LANG=C.UTF-8
      export LC_ALL=C.UTF-8

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
}
