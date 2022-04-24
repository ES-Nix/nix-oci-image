# When you add custom packages, list them here
{ pkgs }: {
  default = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { };
}