# When you add custom packages, list them here
{ pkgs, podman-rootless }: {

  oci-podman-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/oci-podman-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { podman-rootless = podman-rootless; };


  oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix { podman-rootless = podman-rootless; };


  oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/default.nix { };
  oci-empty = pkgs.callPackage ./oci-empty { };

  default = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { podman-rootless = podman-rootless; };

#  oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { };
#  test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { podman-rootless = podman-rootless; };

}