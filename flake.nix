{
  description = "Flake usado para reunir ferramentas de infraestrutura";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  #inputs = {
  #  secrets.url = "github:PedroRegisPOAR/nix-flake-private-test";
  #};

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgsAllowUnfree = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };

      in
      {
        # For FREE packages use:
        #packages.podman = import ./podman.nix {
        #    pkgs = nixpkgs.legacyPackages.${system};
        #};

        packages.default = (import ./default.nix {
          pkgs = pkgsAllowUnfree;
        }).image;

        defaultPackage = self.packages.${system}.default;


        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            which
            file
            coreutils
          ];
        };

      });

}
