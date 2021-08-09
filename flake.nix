{
  description = "A nix flake minimal flask example with podman rootless";

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
      in
      {
        packages.empty = import ./empty-oci.nix {
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

        packages.oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = import ./oci-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.busybox-sandbox-shell-nix-flakes = import ./busybox-sandbox-shell-nix-flakes-oci.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            podman-rootless.defaultPackage.${system}
          ];

          shellHook = ''
            # TODO:
            export TMPDIR=/tmp
            echo "Entering the nix devShell"
          '';
        };
      });
}
