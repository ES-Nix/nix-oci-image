{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildLayeredImage {
  name = "busybox-sandbox-shell-nix-flakes";
  tag = "0.0.1";

  contents = with pkgs; [
    bashInteractive
    busybox-sandbox-shell
    cacert
    coreutils
    nixFlakes
  ];

  config = {
    Entrypoint = [ "${pkgs.busybox-sandbox-shell}/bin/sh" ];
    Env = with pkgs; [
      "ENV=/etc/profile"
      "GIT_SSL_CAINFO=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "HOME=/root"
      "MANPATH=/root/.nix-profile/share/man:/home/nixuser/.nix-profile/share/man:/run/current-system/sw/share/man"
      "NIX_PAGER=cat"
      "NIX_PATH=nixpkgs=${nixFlakes}"
      "NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "PATH=/root/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${pkgs.busybox-sandbox-shell}/bin:${nixFlakes}/bin:/bin:/sbin:/usr/bin:/usr/sbin"
      "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=root"
    ];
  };
}
