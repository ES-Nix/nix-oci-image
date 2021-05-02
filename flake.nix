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
            ${build_wip}/bin/build_wip
        '';

        builds = pkgsAllowUnfree.writeShellScriptBin "builds" ''
            nix build .#wip && podman load < result
            nix build .#oci-ca-bundle && podman load < result
            nix build .#empty && podman load < result
            # nix build .#toybox-static-oci && podman load < result
            nix build .#toybox-oci-nixpkgs && podman load < result
            nix build .#nix_runAsRoot && podman load < result
            nix build .#nix_runAsRoot_minimal && podman load < result
            nix build .#nix-unpriviliged && podman load < result
            nix build .#nix-static-bare && podman load < result
            nix build .#nix-static-bash-interactive-coreutils && podman load < result
        '';

        build_wip = pkgsAllowUnfree.writeShellScriptBin "build_wip" ''

            TOYBOX_PATH='./root/toybox'
            TOYBOX_VOLUME='volume_toybox'
            ALPINE='docker.io/library/alpine:3.13.5'
            WIP_OCI='localhost/nix_wip:0.0.1'
            CONTAINER='foo'
            NIX_IMAGE='nix:0.0.1'

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

      in
      {

        packages.nix_runAsRoot = import ./src/nix_runAsRoot.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix_runAsRoot_minimal = import ./src/nix_runAsRoot_minimal.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.empty = import ./src/empty-oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix-unpriviliged = import ./src/nix-unpriviliged.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.toybox-static-oci = import ./src/toybox-static-oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.toybox = import ./src/toybox.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.toybox-oci-nixpkgs = import ./src/toybox-oci-nixpkgs.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.build-environment-to-build-toybox-staticaly = import ./src/build-environment-to-build-toybox-staticaly.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.wip = import ./src/wip.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-ca-bundle = import ./src/oci-ca-bundle.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix-static-bare = import ./src/nix-static-bare.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix-static-bash-interactive-coreutils = import ./src/nix-static-bash-interactive-coreutils.nix {
          pkgs = nixpkgs.legacyPackages.${system};
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
          ];

          shellHook = ''
            hook
          '';
        };
      });
}
