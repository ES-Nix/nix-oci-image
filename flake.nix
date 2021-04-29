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

        packages.nixOCIImage = import ./src/nixOCIImage.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.empty = import ./src/empty-image-zero-size.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };

        packages.slim = import ./src/slim.nix {
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
