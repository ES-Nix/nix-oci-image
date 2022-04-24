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
      in
      {
        # du -hs $(readlink -f result)
        packages.oci-empty-image = import ./oci-empty-image.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix-static = import ./nix.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.busybox-sandbox-shell = import ./busybox-sandbox-shell-oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.toybox-static = import ./src/nix/core/toybox-static.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-toybox-static = import ./src/nix/core/oci-toybox-static.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-busybox-sandbox-shell-ca-bundle-tmp = import ./oci-busybox-sandbox-shell-ca-bundle-tmp.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.ca-bundle-etc-passwd-etc-group-sudo-su = import ./ca-bundle-etc-passwd-etc-group-sudo-su.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = import ./oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.oci-nix-static-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-nix-static-ca-bundle-etc-passwd-etc-group-tmp.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.busybox-sandbox-shell-nix-flakes = import ./busybox-sandbox-shell-nix-flakes-oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

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
