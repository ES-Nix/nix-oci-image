{
  description = "Flake do income-back";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    podman-rootless.url = "github:ES-Nix/podman-rootless";
  };

  outputs = { self, nixpkgs, flake-utils, podman-rootless }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgsAllowUnfree = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };

        hook = pkgsAllowUnfree.writeShellScriptBin "hook" ''
          export TMPDIR=/tmp

          ${wrapp}/bin/wrapp
        '';

        wrapp = pkgsAllowUnfree.writeShellScriptBin "wrapp" ''
          ${builds}/bin/builds
          #${build_wip}/bin/build_wip

          #${nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox}/bin/nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox
          #${nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-commited}/bin/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-commited
          ${nix-static-toybox-tianon}/bin/nix-static-toybox-tianon
        '';

        builds = pkgsAllowUnfree.writeShellScriptBin "builds" ''
          nix build .#nix-static-ca-bundle-etc-passwd-etc-group-tmp && podman load < result
          nix build .#oci-ca-bundle && podman load < result
          nix build .#empty && podman load < result
          # nix build .#toybox-static-oci && podman load < result
          nix build .#toybox-oci-nixpkgs && podman load < result
          nix build .#nix_runAsRoot && podman load < result
          nix build .#nix_runAsRoot_minimal && podman load < result
          nix build .#nix-unpriviliged && podman load < result
          nix build .#nix-static-bare && podman load < result
          nix build .#nix-static-bash-interactive-coreutils && podman load < result
          nix build .#nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp && podman load < result
          nix build .#nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp && podman load < result

          nix build .#future && podman load < result
          nix build .#tests
        '';

        build_wip = pkgsAllowUnfree.writeShellScriptBin "build_wip" ''

            TOYBOX_PATH='./root/toybox'
            TOYBOX_VOLUME='volume_toybox'
            ALPINE='docker.io/library/alpine:3.13.5'
            WIP_OCI='localhost/nix-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
            CONTAINER='foo'
            NIX_IMAGE='nix:0.0.1'

            # http://docs.podman.io/en/latest/markdown/podman-volume-ls.1.html#examples
            # http://docs.podman.io/en/latest/markdown/podman-volume-create.1.html#examples
            podman volume rm --force "$TOYBOX_VOLUME"
            podman volume create "$TOYBOX_VOLUME"
            podman \
            run \
            --interactive=true \
            --tty=false \
            --rm=true \
            --user='0' \
            --volume="$TOYBOX_VOLUME":/root \
            "$ALPINE" \
            sh \
            << COMMANDS
            apk update

            apk \
            add \
            --no-cache \
            bash \
            gcc \
            linux-headers \
            make \
            musl-dev

            mkdir /toybox
            cd /toybox

            wget -O toybox.tgz "https://landley.net/toybox/downloads/toybox-0.8.4.tar.gz"
            tar -xf toybox.tgz --strip-components=1
            rm toybox.tgz
            make root BUILTIN=1

            cp /toybox/root/host/fs/bin/toybox /root
            chmod 0755 /root/toybox
            COMMANDS

            podman \
            run \
            --env=USER=nixuser \
            --interactive=true \
            --name="$CONTAINER" \
            --tty=false \
            --rm=false \
            --user='0' \
            --volume="$TOYBOX_VOLUME":/root:ro \
            "$WIP_OCI" \
            "$TOYBOX_PATH" \
            sh \
            << COMMANDS

            /root/toybox cp /root/toybox /home/nixuser/bin

            ./home/nixuser/bin/toybox mkdir /nix
            ./home/nixuser/bin/toybox chmod 0755 -R /home/nixuser/
            ./home/nixuser/bin/toybox chmod 0700 /home/nixuser
            ./home/nixuser/bin/toybox chmod 1777 /tmp
            ./home/nixuser/bin/toybox chown nixuser:nixgroup -R /home/nixuser /nix
            #./home/nixuser/bin/toybox chmod 0700 /root /etc
            COMMANDS

            rm -f oci_diff.txt
            podman diff "$CONTAINER" > oci_diff.txt

            ID=$(
              podman \
              commit \
              "$CONTAINER" \
              "$NIX_IMAGE"
            )

            podman rm --force --ignore "$CONTAINER"

            #
            podman \
            run \
            --interactive=true \
            --name="$CONTAINER" \
            --tty=false \
            --rm=true \
            --user='nixuser' \
            --workdir=/home/nixuser \
            "$NIX_IMAGE" \
            toybox \
            sh \
            << COMMANDS
            echo "Building cowsay"
            nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay

            /nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

            toybox ls -ahl result
            toybox file result

            echo "nix shell nixpkgs#bashInteractive nixpkgs#coreutils"
            nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#bashInteractive nixpkgs#coreutils --command bash -c "./result/bin/cowsay Hi!"

            toybox rm -fr result
            echo "nix store gc"
            nix --experimental-features 'nix-command ca-references flakes' store gc

            #/nix/store/kpjxp14wfib9imz605i7a39jza6854w8-cowsay-3.03+dfsg2/bin/cowsay "Hi!"

            COMMANDS
        '';

        nix-static-toybox-tianon = pkgsAllowUnfree.writeShellScriptBin "nix-static-toybox-tianon" ''
          NIX_VOLUME='nix_volume'
          BASE='localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
          CONTAINER='bar'
          NIX_IMAGE='nix-static-toybox-tianon:0.0.1'

          podman volume rm --force "$NIX_VOLUME"
          podman volume create "$NIX_VOLUME"
          podman \
          run \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='0' \
          --volume="$NIX_VOLUME":/root/copy \
          "$BASE" \
          << COMMANDS
            cp /etc/ssl/certs/ca-bundle.crt /root/copy
            cp /bin/nix /root/copy
          COMMANDS

          podman \
          run \
          --name="$CONTAINER" \
          --interactive=true \
          --tty=false \
          --rm=false \
          --user='0' \
          --volume="$NIX_VOLUME":/root/copy:ro \
          docker.io/tianon/toybox:0.8.4 \
          bash \
          << COMMANDS

          mkdir -p /etc/ssl/certs
          cp /root/copy/ca-bundle.crt /etc/ssl/certs
          cp /root/copy/nix /bin


          echo 'nixuser:x:6789:12345::/home/nixuser:/bin/sh' >> /etc/passwd
          echo 'nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin' >> /etc/passwd
          echo 'nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin' >> /etc/passwd

          echo 'nixgroup:x:12345:' >> /etc/group
          echo 'nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32' >> /etc/group

          mkdir -p /nix /home/nixuser/tmp

          mkdir -p /home/nixuser/.config/nix


          echo 'experimental-features = nix-command flakes ca-references' >> /home/nixuser/.config/nix/nix.conf

          mkdir -p /root/.config/nix
          echo 'experimental-features = nix-command flakes ca-references' >> /root/.config/nix/nix.conf

          mkdir -p /root/.config/nixpkgs
          mkdir -p /home/nixuser/.config/nixpkgs
          echo '{ allowUnfree = true; }' >>  /root/.config/nixpkgs/config.nix
          echo '{ allowUnfree = true; }' >> ~/.config/nixpkgs/config.nix

          chmod 0755 -R /home/nixuser/
          chmod 0700 /home/nixuser
          chmod 1777 /tmp /home/nixuser/tmp
          chown nixuser:nixgroup -R /home/nixuser /nix
          # chmod 0700 /root /etc
          COMMANDS

          rm -f oci_diff.txt
          podman diff "$CONTAINER" > oci_diff.txt

          ID=$(
            podman \
            commit \
            "$CONTAINER" \
            "$NIX_IMAGE"
          )

          podman rm --force --ignore "$CONTAINER"

          xhost +
          podman \
          run \
          --env="DISPLAY=:0.0" \
          --env="NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='nixuser' \
          --workdir=/home/nixuser \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/"$NIX_IMAGE" \
          << COMMANDS
              echo 'Running test'
              id
              nix shell nixpkgs#xorg.xclock --command timeout 2 xclock
              nix shell nixpkgs#python38Full --command python -c 'from tkinter import Tk; Tk()'
              exit 0
          COMMANDS
          xhost -
        '';
        /*
          podman \
          run \
          --env="DISPLAY=:0" \
          --env="NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='0' \
          --workdir=/home/nixuser \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/"$NIX_IMAGE" \
          << COMMANDS
              echo 'Running test'
              id
              nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
              nix develop github:ES-Nix/poetry2nix-examples/2cb6663e145bbf8bf270f2f45c869d69c657fef2
              nix build github:ES-Nix/poetry2nix-examples/2cb6663e145bbf8bf270f2f45c869d69c657fef2#poetry2nixOCIImage
              exit 0
          COMMANDS

        */

        nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox = pkgsAllowUnfree.writeShellScriptBin "nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox" ''

            TOYBOX_PATH='./root/toybox'
            TOYBOX_VOLUME='volume_toybox'
            ALPINE='docker.io/library/alpine:3.13.5'
            BASE='localhost/nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
            CONTAINER='foo'
            NIX_IMAGE='nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox:0.0.1'

            podman volume rm --force "$TOYBOX_VOLUME"
            podman volume create "$TOYBOX_VOLUME"
            podman \
            run \
            --interactive=true \
            --tty=false \
            --rm=true \
            --user='0' \
            --volume="$TOYBOX_VOLUME":/root \
            "$ALPINE" \
            sh \
            << COMMANDS
            apk update

            apk \
            add \
            --no-cache \
            bash \
            gcc \
            linux-headers \
            make \
            musl-dev

            mkdir /toybox
            cd /toybox

            wget -O toybox.tgz "https://landley.net/toybox/downloads/toybox-0.8.4.tar.gz"
            tar -xf toybox.tgz --strip-components=1
            rm toybox.tgz
            make root BUILTIN=1

            cp -r /toybox/root/host/fs/bin /root
            #chmod 0755 /root/toybox
            COMMANDS

            podman \
            run \
            --interactive=true \
            --name="$CONTAINER" \
            --tty=false \
            --rm=false \
            --user='0' \
            --volume="$TOYBOX_VOLUME":/root:ro \
            "$BASE" \
            << COMMANDS

            ./root/toybox mkdir -p /root/toybox/home/nixuser/bin

            ./root/toybox cp /root/toybox /root/toybox/home/nixuser/bin

            ./root/toybox mkdir /nix
            ./root/toybox chmod 0755 -R /home/nixuser/ /nix
            ./root/toybox chmod 0700 /home/nixuser
            ./root/toybox chmod 1777 /tmp
            ./root/toybox chown nixuser:nixgroup -R /home/nixuser /nix

            #./home/nixuser/bin/toybox chmod 0700 /root /etc
            COMMANDS

            rm -f oci_diff.txt
            podman diff "$CONTAINER" > oci_diff.txt

            ID=$(
              podman \
              commit \
              "$CONTAINER" \
              "$NIX_IMAGE"
            )

            podman rm --force --ignore "$CONTAINER"
        '';

        nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-commited = pkgsAllowUnfree.writeShellScriptBin "nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-commited" ''

            BASE='localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
            CONTAINER='to-be-commited'
            NIX_IMAGE='nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-commited:0.0.1'

            podman \
            run \
            --interactive=true \
            --name="$CONTAINER" \
            --tty=false \
            --rm=false \
            --user='0' \
            "$BASE" \
            << COMMANDS
              chmod 0755 -R /home/nixuser/ /nix
              chmod 0700 /home/nixuser
              chmod 1777 /tmp
              chown nixuser:nixgroup -R /home/nixuser /nix
              # chmod 0700 /root /etc
            COMMANDS

            ID=$(
              podman \
              commit \
              "$CONTAINER" \
              "$NIX_IMAGE"
            )

            podman rm --force --ignore "$CONTAINER"

            #
            podman \
            run \
            --env="DISPLAY=:0" \
            --interactive=true \
            --tty=false \
            --rm=true \
            --user='nixuser' \
            --workdir=/home/nixuser \
            --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
            localhost/"$NIX_IMAGE" \
            << COMMANDS
                echo 'Running test'
                id
                nix shell nixpkgs#xorg.xclock --command timeout 2 xclock
                exit 0
            COMMANDS
        '';

        oci-nix-static = pkgsAllowUnfree.writeShellScriptBin "oci-nix" ''
          xhost +
          podman \
          run \
          --env="DISPLAY=:0" \
          --env="NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" \
          --interactive=true \
          --tty=true \
          --rm=true \
          --user='nixuser' \
          --workdir=/home/nixuser/code \
          --volume="$(pwd)":/home/nixuser/code \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/nix-static-toybox-tianon:0.0.1
        '';

        oci-nix-kvm-broken = pkgsAllowUnfree.writeShellScriptBin "oci-nix-kvm-broken" ''
          podman \
          run \
          --cap-add ALL \
          --device=/dev/kvm \
          --env="DISPLAY=:0" \
          --interactive=true \
          --tty=true \
          --rm=true \
          --user='0' \
          --volume="$(pwd)":/home/nixuser/code \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          docker.io/nixpkgs/nix-flakes \
          << COMMAND
          nix --experimental-features 'nix-command ca-references flakes' build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
          COMMAND
        '';

        oci-nix-kvm-lnl7 = pkgsAllowUnfree.writeShellScriptBin "oci-nix-kvm-lnl7" ''
          podman \
          run \
          --cap-add ALL \
          --device=/dev/kvm \
          --env="DISPLAY=:0" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='0' \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          docker.io/lnl7/nix:2.3.6 \
          << COMMAND
          nix-env --install --attr nixpkgs.commonsCompress nixpkgs.gnutar nixpkgs.lzma.bin nixpkgs.git
          echo 'Started hard build:'
          nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run "nix --experimental-features 'nix-command ca-references flakes' build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare && timeout 1 sleep 200 || ( [[ $? -eq 124 ]] && echo 'Timeout reached, but that is OK' ) && exit 0"
          exit 0
          COMMAND
        '';

        oci-nix-test-timeout = pkgsAllowUnfree.writeShellScriptBin "oci-nix-kvm-lnl7" ''
          podman \
          run \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='0' \
          docker.io/lnl7/nix:2.3.6 \
          << COMMAND
            timeout 1 sleep 200 || ( [[ $? -eq 124 ]] && echo 'Timeout reached, but that is OK' ) && exit 0
          COMMAND
        '';

        oci-nix-toybox-test = pkgsAllowUnfree.writeShellScriptBin "oci-nix-toybox-test" ''
          xhost +
          nix build .#nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp

          podman load < result

          podman \
          run \
          --cap-add ALL \
          --device=/dev/kvm \
          --env="DISPLAY=:0.0" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='nixuser' \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
          << COMMAND
          /home/nixuser/bin/toybox id
          COMMAND

          podman \
          run \
          --env="DISPLAY=:0.0" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='0' \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
          << COMMAND
            /home/nixuser/bin/toybox id
            /home/nixuser/bin/toybox stat /proc
            /bin/nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#xorg.xclock --command /home/nixuser/bin/toybox timeout 2 xclock
          COMMAND

          podman \
          run \
          --env="DISPLAY=:0.0" \
          --interactive=true \
          --tty=false \
          --rm=true \
          --user='nixuser' \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
          << COMMAND
            /home/nixuser/bin/toybox id
            /home/nixuser/bin/toybox stat /proc
            /bin/nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#xorg.xclock --command /home/nixuser/bin/toybox timeout 2 xclock
          COMMAND
        '';

        oci-nix-toybox = pkgsAllowUnfree.writeShellScriptBin "oci-nix-toybox" ''
          xhost +
          nix build .#nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp

          podman load < result

          podman \
          run \
          --cap-add ALL \
          --device=/dev/kvm \
          --env="DISPLAY=:0.0" \
          --interactive=true \
          --tty=true \
          --rm=true \
          --user='nixuser' \
          --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
          localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1
        '';
      in
      {

        packages.oci = import ./src/oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          podman-rootless = podman-rootless.defaultPackage.${system};
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            #podman-rootless.defaultPackage.${system}
            bashInteractive
            coreutils
            file
            which
            git
            python3Minimal
            hook
            oci-nix-static
            nix-static-toybox-tianon
            oci-nix-toybox
            oci-nix-toybox-test
          ];

          shellHook = ''
            hook
          '';
        };
      });
}

#        nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox = pkgsAllowUnfree.writeShellScriptBin "nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox" ''
#
#            TOYBOX_PATH='./root/fs'
#            TOYBOX_VOLUME='volume_toybox'
#            ALPINE='docker.io/library/alpine:3.13.5'
#            BASE='localhost/nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1'
#            CONTAINER='foo'
#            NIX_IMAGE='nix-static-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-toybox:0.0.1'
#
#            podman volume rm --force "$TOYBOX_VOLUME"
#            podman volume create "$TOYBOX_VOLUME"
#            podman \
#            run \
#            --interactive=true \
#            --tty=false \
#            --rm=true \
#            --user='0' \
#            --volume="$TOYBOX_VOLUME":/root \
#            "$ALPINE" \
#            sh \
#            << COMMANDS
#            apk update
#
#            apk \
#            add \
#            --no-cache \
#            bash \
#            gcc \
#            linux-headers \
#            make \
#            musl-dev
#
#            mkdir /toybox
#            cd /toybox
#
#            wget -O toybox.tgz "https://landley.net/toybox/downloads/toybox-0.8.4.tar.gz"
#            tar -xf toybox.tgz --strip-components=1
#            rm toybox.tgz
#            make root BUILTIN=1
#
#            cp -r /toybox/root/host/fs /root
#            #chmod 0755 /root/toybox
#
#            echo 'nixuser:x:12345:6789::/home/nixuser:/home/nixuser/bin/sh' >> /root/fs/etc/passwd
#            echo 'nixgroup:x:6789:' >> /root/fs/etc/group
#
#            mkdir --parent /root/fs/home/nixuser/.config/nix
#            echo 'experimental-features = nix-command flakes ca-references' >> /root/fs/home/nixuser/.config/nix/nix.conf
#
#            mkdir --parent /root/fs/root/.config/nix
#            echo 'experimental-features = nix-command flakes ca-references' >> /root/fs/root/.config/nix/nix.conf
#
#            cat << 'EOF' >> /root/fs/etc/group
#            nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32
#            EOF
#
#            cat << 'EOF' >> /root/fs/etc/passwd
#            nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin
#            nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin
#            nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin
#            nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin
#            nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin
#            nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin
#            nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin
#            nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin
#            nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin
#            nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin
#            nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin
#            nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin
#            nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin
#            nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin
#            nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin
#            nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin
#            nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin
#            nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin
#            nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin
#            nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin
#            nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin
#            nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin
#            nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin
#            nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin
#            nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin
#            nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin
#            nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin
#            nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin
#            nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin
#            nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin
#            nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin
#            nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin
#            EOF
#
#            COMMANDS

#            #
#            podman \
#            run \
#            --cap-add ALL \
#            --device=/dev/kvm \
#            --env="DISPLAY=\${DISPLAY:-:0}" \
#            --interactive=true \
#            --tty=false \
#            --rm=true \
#            --user='nixuser' \
#            --workdir=/home/nixuser \
#            --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
#            "$NIX_IMAGE" \
#            << COMMANDS
#            echo 'Building VM'
#
#            #toybox timeout 1 toybox sleep 1000
#
#            nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
#
#            echo 'Build finished!'
#            echo 'Trying to run the VM!'
#            timeout 50 result/runVM
#
#            echo 'It seens to have worked!'
#            COMMANDS
