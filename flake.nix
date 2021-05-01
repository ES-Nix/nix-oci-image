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

      in
      {

        packages.nix_runAsRoot = import ./src/nix_runAsRoot.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix_runAsRoot_minimal = import ./src/nix_runAsRoot_minimal.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.empty = import ./src/empty-image-zero-size.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.slim = import ./src/slim.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.nix-unpriviliged = import ./src/nix-unpriviliged.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.toybox-oci = import ./src/toybox-oci.nix {
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

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            podman-rootless.defaultPackage.${system}
            bashInteractive
            coreutils
            file
            which
            git
            python3Minimal
          ];

          shellHook = ''
            export TMPDIR=/tmp
          '';
        };
      });
}
