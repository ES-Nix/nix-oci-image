# When you add custom packages, list them here
{ pkgs, podman-rootless }: {

  oci-nix = pkgs.callPackage ./oci-nix { };
  oci-podman-nix = pkgs.callPackage ./oci-nix/oci-podman-nix.nix { podman-rootless = podman-rootless; };
  test-oci-podman-nix = pkgs.callPackage ./oci-nix/test-oci-podman-nix.nix { podman-rootless = podman-rootless; };
  build-and-load-oci-podman-nix = pkgs.callPackage ./oci-nix/build-and-load-oci-podman-nix.nix { podman-rootless = podman-rootless; };
  build-local-or-remote = pkgs.callPackage ./oci-nix/build-local-or-remote.nix { };


  oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/oci-podman-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp.nix { podman-rootless = podman-rootless; };


  oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp = pkgs.callPackage ./oci-nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp/default.nix { };
  oci-empty = pkgs.callPackage ./oci-empty { };

  entrypoint-with-corrected-gid-and-uid = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid { };
  change-gid-and-or-uid-if-different-of-given-path = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid/change-gid-and-or-uid-if-different-of-given-path.nix { };
  oci-nix-entrypoint = pkgs.callPackage ./oci-nix-entrypoint { };
  oci-podman-nix-entrypoint = pkgs.callPackage ./oci-nix-entrypoint/oci-podman-nix-entrypoint.nix { podman-rootless = podman-rootless; };


  oci-podman-busybox-sandbox-shell = pkgs.callPackage ./oci-busybox-sandbox-shell/oci-podman-busybox-sandbox-shell.nix { podman-rootless = podman-rootless; };
  oci-busybox-sandbox-shell = pkgs.callPackage ./oci-busybox-sandbox-shell { };


#  oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { };
#  test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { podman-rootless = podman-rootless; };

}