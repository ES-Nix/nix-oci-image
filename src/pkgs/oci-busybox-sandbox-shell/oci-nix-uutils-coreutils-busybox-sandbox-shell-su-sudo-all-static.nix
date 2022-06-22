{ pkgs ? import <nixpkgs> { } }:
let
  troubleshoot-packages = with pkgs; [
    hello
    file
    findutils
    ripgrep
    nano
    which
    strace
  ];
in
pkgs.dockerTools.buildImage {
  name = "oci-nix-toybox-busybox-sandbox-shell-all-static";
  tag = "0.0.1";

  contents = with pkgs.pkgsStatic; [
    busybox-sandbox-shell
    nix
    toybox

    (sudo.override { pam = null; })
    (shadow.override { pam = null; }).su
  ]
  # ++ troubleshoot-packages
  ++
  (with pkgs; [
    # bashInteractive
    # coreutils
  ]
  );

  config = {
    #Cmd = [ "/bin" ];
    Entrypoint = [ "${pkgs.pkgsStatic.busybox-sandbox-shell}/bin/sh" ];
    # Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];

    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      #"USER=nixuser"
      "USER=root"
      # "HOME=/home/nixuser"
      # "PATH=/bin:/home/nixuser/bin"
      # "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      # "TMPDIR=/home/nixuser/tmp"
    ];
  };
}
