{
  description = "A nix flake minimal flask example with podman rootless";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    podman-rootless.url = "github:ES-Nix/podman-rootless/from-nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, podman-rootless }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgsAllowUnfree = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };

        packages = (import ./src/pkgs { pkgs = pkgsAllowUnfree; podman-rootless = podman-rootless.packages.${system}.podman; });
      in
      rec {
        # du -hs $(readlink -f result)
#        packages.oci-empty-image = import ./oci-empty-image.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.nix-static = import ./nix.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.busybox-sandbox-shell = import ./busybox-sandbox-shell-oci.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.toybox-static = import ./src/nix/core/toybox-static.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-toybox-static = import ./src/nix/core/oci-toybox-static.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-busybox-sandbox-shell-ca-bundle-tmp = import ./oci-busybox-sandbox-shell-ca-bundle-tmp.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.ca-bundle-etc-passwd-etc-group-sudo-su = import ./ca-bundle-etc-passwd-etc-group-sudo-su.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.oci-nix-static-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-ca-bundle-etc-passwd-etc-group-tmp.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };
#
#        packages.busybox-sandbox-shell-nix-flakes = import ./busybox-sandbox-shell-nix-flakes-oci.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };


#        packages.oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
#          pkgs = nixpkgs.legacyPackages.${system};
#        };

        #
        inherit packages;

        apps.oci-podman-nix = flake-utils.lib.mkApp {
          name = "oci-podman-nix";
          drv = packages.oci-podman-nix;
        };

        apps.test-oci-podman-nix = flake-utils.lib.mkApp {
          name = "test-oci-podman-nix";
          drv = packages.test-oci-podman-nix;
        };

        apps.build-and-load-oci-podman-nix = flake-utils.lib.mkApp {
          name = "build-and-load-oci-podman-nix";
          drv = packages.build-and-load-oci-podman-nix;
        };

        apps.oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = flake-utils.lib.mkApp {
          name = "oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp";
          drv = packages.oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp;
        };

        apps.oci-podman-nix-entrypoint = flake-utils.lib.mkApp {
          name = "oci-podman-nix-entrypoint";
          drv = packages.oci-podman-nix-entrypoint;
        };

        apps.oci-podman-busybox-sandbox-shell = flake-utils.lib.mkApp {
          name = "oci-podman-busybox-sandbox-shell";
          drv = packages.oci-podman-busybox-sandbox-shell;
        };

        apps.oci-podman-nix-toybox-busybox-sandbox-shell-all-static = flake-utils.lib.mkApp {
          name = "oci-podman-nix-toybox-busybox-sandbox-shell-all-static";
          drv = packages.oci-podman-nix-toybox-busybox-sandbox-shell-all-static;
        };

        apps.oci-podman-openssh-server = flake-utils.lib.mkApp {
          name = "oci-podman-openssh-server";
          drv = packages.oci-podman-openssh-server;
        };

        apps.fmt-nix-check = flake-utils.lib.mkApp {
          name = "fmt-nix-check";
          drv = packages.fmt-nix-check;
        };

        apps.fmt-nix-fix = flake-utils.lib.mkApp {
          name = "fmt-nix-fix";
          drv = packages.fmt-nix-fixk;
        };

        apps.fmt-nix-fix-and-check = flake-utils.lib.mkApp {
          name = "fmt-nix-fix-and-check";
          drv = packages.fmt-nix-fix-and-check;
        };


#        apps.oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = flake-utils.lib.mkApp {
#          name = "oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su";
#          drv = packages.oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su;
#        };
#
#        apps.test-oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = flake-utils.lib.mkApp {
#          name = "test-oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su";
#          drv = packages.oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su;
#        };
#
#        apps.oci-image-podman-nix-sudo-su = flake-utils.lib.mkApp {
#          name = "oci-image-podman-nix-sudo-su";
#          drv = packages.test_nix-sudo-su;
#        };
#
#        apps.test_nix-sudo-su = flake-utils.lib.mkApp {
#          name = "test_nix-sudo-su";
#          drv = packages.test_nix-sudo-su;
#        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            podman-rootless.packages.${system}.podman
          ];

          shellHook = ''
            # TODO:
            export TMPDIR=/tmp
            echo "Entering the nix devShell"

          '';
        };
      });
}
