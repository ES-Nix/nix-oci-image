# When you add custom packages, list them here
{ pkgs, podman-rootless }: {

  oci-nix = pkgs.callPackage ./oci-nix { };
  oci-podman-nix = pkgs.callPackage ./oci-nix/oci-podman-nix.nix { podman-rootless = podman-rootless; };
  test-oci-podman-nix = pkgs.callPackage ./oci-nix/test-oci-podman-nix.nix { podman-rootless = podman-rootless; };


  oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix { podman-rootless = podman-rootless; };


  oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/default.nix { };
  oci-empty = pkgs.callPackage ./oci-empty { };

  entrypoint-with-corrected-gid-and-uid = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid { };
  change-gid-and-or-uid-if-different-of-given-path = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid/change-gid-and-or-uid-if-different-of-given-path.nix { };

  # oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-bash-coreutiloci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmps-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/oci-podman-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { };

#  oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { };
#  test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { podman-rootless = podman-rootless; };

}