# When you add custom packages, list them here
{ pkgs, podman-rootless }: {

  oci-hello = pkgs.callPackage ./oci-hello { };

  oci-nix = pkgs.callPackage ./oci-nix { };
  oci-podman-nix = pkgs.callPackage ./oci-nix/oci-podman-nix.nix { podman-rootless = podman-rootless; };
  oci-nix-sudo-su = pkgs.callPackage ./oci-nix/oci-nix-sudo-su.nix { };
  oci-podman-nix-sudo-su = pkgs.callPackage ./oci-nix/oci-podman-nix-sudo-su.nix { podman-rootless = podman-rootless; };
  test-oci-podman-nix = pkgs.callPackage ./oci-nix/test-oci-podman-nix.nix { podman-rootless = podman-rootless; };
  build-and-load-oci-podman-nix = pkgs.callPackage ./oci-nix/build-and-load-oci-podman-nix.nix { podman-rootless = podman-rootless; };
  build-local-or-remote = pkgs.callPackage ./oci-nix/build-local-or-remote.nix { };


  oci-nix-busybox-sandbox-shell = pkgs.callPackage ./oci-busybox-sandbox-shell/default.nix { };

  oci-empty = pkgs.callPackage ./oci-empty { };

  entrypoint-with-corrected-gid-and-uid = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid { };
  change-gid-and-or-uid-if-different-of-given-path = pkgs.callPackage ./entrypoint-with-corrected-gid-and-uid/change-gid-and-or-uid-if-different-of-given-path.nix { };
  oci-nix-entrypoint = pkgs.callPackage ./oci-nix-entrypoint { };
  oci-podman-nix-entrypoint = pkgs.callPackage ./oci-nix-entrypoint/oci-podman-nix-entrypoint.nix { podman-rootless = podman-rootless; };


  oci-podman-nix-toybox-busybox-sandbox-shell-all-static = pkgs.callPackage ./oci-busybox-sandbox-shell/oci-podman-nix-toybox-busybox-sandbox-shell-all-static.nix { podman-rootless = podman-rootless; };
  test_oci-podman-nix-toybox-busybox-sandbox-shell-all-static = pkgs.callPackage ./oci-busybox-sandbox-shell/test_oci-podman-nix-toybox-busybox-sandbox-shell-all-static.nix { podman-rootless = podman-rootless; };
  oci-nix-toybox-busybox-sandbox-shell-all-static = pkgs.callPackage ./oci-busybox-sandbox-shell/oci-nix-toybox-busybox-sandbox-shell-all-static.nix { };
  oci-podman-busybox-sandbox-shell = pkgs.callPackage ./oci-busybox-sandbox-shell/oci-podman-busybox-sandbox-shell.nix { podman-rootless = podman-rootless; };
  oci-busybox-sandbox-shell = pkgs.callPackage ./oci-busybox-sandbox-shell { };


  oci-podman-openssh-server = pkgs.callPackage ./oci-openssh-server/oci-podman-openssh-server.nix { podman-rootless = podman-rootless; };
  #  oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su { };
  #  test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su = pkgs.callPackage ./oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su/test_oci-nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su.nix { podman-rootless = podman-rootless; };


  fmt-nix-check = pkgs.callPackage ./fmt-nix-fix-and-check/fmt-nix-check.nix { };
  fmt-nix-fix = pkgs.callPackage ./fmt-nix-fix-and-check/fmt-nix-fix.nix { };
  fmt-nix-fix-and-check = pkgs.callPackage ./fmt-nix-fix-and-check { };


  oci-chromium = pkgs.callPackage ./oci-chromium { };
  oci-podman-chromium = pkgs.callPackage ./oci-chromium/oci-podman-chromium.nix { podman-rootless = podman-rootless; };

  oci-xorg-pkgsstatic-xclock = pkgs.callPackage ./oci-xorg-pkgsStatic-xclock { };
  oci-podman-xorg-pkgsstatic-xclock = pkgs.callPackage ./oci-xorg-pkgsStatic-xclock/oci-podman-xorg-pkgsstatic-xclock.nix { podman-rootless = podman-rootless; };

  oci-geogebra = pkgs.callPackage ./oci-geogebra { };
  oci-podman-geogebra = pkgs.callPackage ./oci-geogebra/oci-podman-geogebra.nix { podman-rootless = podman-rootless; };

  entrypoint-fixes = pkgs.callPackage ./entrypoint-fixes { };
}
